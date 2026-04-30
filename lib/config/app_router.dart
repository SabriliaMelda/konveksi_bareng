import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Auth ──
import '../screens/auth/welcome.dart';
import '../screens/auth/login.dart';
import '../screens/auth/register.dart';
import '../screens/auth/verification.dart';
import '../screens/auth/find_account.dart';
import '../screens/auth/account_screen.dart';
import '../screens/auth/security_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/biometric_lock_screen.dart';
import '../services/biometric_service.dart';

// ── Main ──
import '../screens/main/home.dart';
import '../screens/main/settings.dart';
import '../screens/main/profile.dart';
import '../screens/main/wishlist.dart';
import '../screens/main/chat.dart';

// ── Finance ──
import '../screens/home/finance/finance_screen.dart';
import '../screens/home/finance/profit_loss_screen.dart';
import '../screens/home/finance/purchase_screen.dart';
import '../screens/home/finance/sales_screen.dart';
import '../screens/home/finance/payment_screen.dart';
import '../screens/home/finance/income_screen.dart';
import '../screens/home/finance/expense_screen.dart';
import '../screens/home/finance/operational_screen.dart';
import '../screens/home/finance/electricity_screen.dart';
import '../screens/home/finance/project_finance_screen.dart';
import '../services/payment_service.dart';

// ── Project ──
import '../screens/home/project/manage_project_screen.dart';
import '../screens/home/project/project_list_screen.dart';
import '../screens/home/project/project_detail_screen.dart';
import '../screens/home/project/work_order_screen.dart';
import '../screens/home/project/meeting.dart';
import '../screens/home/project/create_meeting_screen.dart';

// ── Worker ──
import '../screens/home/worker/worker_screen.dart';
import '../screens/home/worker/worker_list_screen.dart';
import '../screens/home/worker/worker_detail_screen.dart';
import '../screens/home/worker/wage_screen.dart';
import '../screens/home/worker/wage_billing_status_screen.dart';

// ── Schedule ──
import '../screens/home/schedule/unified_schedule_screen.dart';

// ── Inventory ──
import '../screens/home/inventory/raw_material_screen.dart';
import '../screens/home/inventory/shipment_screen.dart';
import '../screens/home/inventory/shopping_plan_screen.dart';

// ── Production ──
import '../screens/home/production/pattern_screen.dart';

// ── Marketplace ──
import '../screens/marketplace/marketplace.dart';
import '../screens/marketplace/checkout.dart';
import '../screens/marketplace/bookmark_menu_screen.dart';

// ── Promotion ──
import '../screens/home/promotion/promotion_screen.dart';

// ── Common ──
import '../screens/common/simple_placeholder_page.dart';

// ── Shell ──
import '../widgets/main_shell.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

Page<void> _fadePage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: offsetAnimation, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

Page<void> _softFadePage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

const _authOnlyPaths = <String>{
  '/welcome',
  '/login',
  '/register',
  '/verification',
  '/find-account',
  '/account',
  '/security',
  '/role-selection',
};

Future<String?> _authRedirect(
    BuildContext context, GoRouterState state) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final hasToken = token != null && token.isNotEmpty;
  final loc = state.matchedLocation;
  final isAuthOnly = _authOnlyPaths.contains(loc);
  final isLock = loc == '/biometric-lock';

  // Belum login → lempar ke welcome (kecuali sudah di halaman auth).
  if (!hasToken && !isAuthOnly && !isLock) return '/welcome';

  // Sudah login tapi masih di halaman auth → ke home.
  // (lock screen ditangani di bawah)
  if (hasToken && isAuthOnly) return '/home';

  // Sudah login, cek biometrik.
  if (hasToken) {
    final needsUnlock = await BiometricService.needsUnlock();
    if (needsUnlock && !isLock) return '/biometric-lock';
    if (!needsUnlock && isLock) return '/home';
  }
  return null;
}

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/welcome',
  redirect: _authRedirect,
  routes: [
    // ── Auth routes ──
    GoRoute(
        path: '/welcome', pageBuilder: (_, s) => _fadePage(WelcomeScreen(), s)),
    GoRoute(path: '/login', pageBuilder: (_, s) => _fadePage(LoginScreen(), s)),
    GoRoute(
        path: '/register',
        pageBuilder: (_, s) => _fadePage(RegisterScreen(), s)),
    GoRoute(
        path: '/verification',
        pageBuilder: (_, s) => _fadePage(VerificationScreen(), s)),
    GoRoute(
        path: '/find-account',
        pageBuilder: (_, s) => _fadePage(FindAccountScreen(), s)),
    GoRoute(
        path: '/account', pageBuilder: (_, s) => _fadePage(AccountScreen(), s)),
    GoRoute(
        path: '/security',
        pageBuilder: (_, s) => _fadePage(SecurityScreen(), s)),
    GoRoute(
        path: '/role-selection',
        pageBuilder: (_, s) => _fadePage(const RoleSelectionScreen(), s)),
    GoRoute(
        path: '/biometric-lock',
        pageBuilder: (_, s) => _fadePage(const BiometricLockScreen(), s)),

    // ── Main routes (persistent shell with bottom nav) ──
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
            path: '/home', pageBuilder: (_, s) => _fadePage(HomeScreen(), s)),
        GoRoute(
          path: '/wishlist',
          pageBuilder: (_, s) {
            final prevRoute = s.uri.queryParameters['prev'] ?? '/home';
            return _fadePage(WishlistScreen(prevRoute: prevRoute), s);
          },
        ),
        GoRoute(
            path: '/settings',
            pageBuilder: (_, s) => _fadePage(SettingsScreen(), s)),
        GoRoute(
          path: '/chat',
          pageBuilder: (_, s) {
            final prevRoute = s.uri.queryParameters['prev'] ?? '/home';
            return _softFadePage(ChatScreen(prevRoute: prevRoute), s);
          },
        ),
        GoRoute(
            path: '/profile',
            pageBuilder: (_, s) => _fadePage(ProfileScreen(), s)),
      ],
    ),

    // ── Finance routes ──
    GoRoute(
        path: '/finance',
        pageBuilder: (_, s) => _softFadePage(FinanceScreen(), s)),
    GoRoute(
        path: '/profit-loss',
        pageBuilder: (_, s) => _fadePage(ProfitLossScreen(), s)),
    GoRoute(
        path: '/purchase',
        pageBuilder: (_, s) {
          final prevRoute = s.uri.queryParameters['prev'] ?? '/home';
          return _fadePage(
            PurchaseScreen(
                order: s.extra as OrderResult?, prevRoute: prevRoute),
            s,
          );
        }),
    GoRoute(
        path: '/purchase-detail',
        pageBuilder: (_, s) {
          final prevRoute = s.uri.queryParameters['prev'] ?? '/purchase';
          return _softFadePage(
            PurchaseDetailScreen(
              order: s.extra as OrderResult,
              prevRoute: prevRoute,
            ),
            s,
          );
        }),
    GoRoute(
        path: '/sales',
        pageBuilder: (_, s) {
          final prevRoute = s.uri.queryParameters['prev'] ?? '/home';
          return _fadePage(SalesScreen(prevRoute: prevRoute), s);
        }),
    GoRoute(
        path: '/payment', pageBuilder: (_, s) => _fadePage(PaymentScreen(), s)),
    GoRoute(
        path: '/income', pageBuilder: (_, s) => _fadePage(IncomeScreen(), s)),
    GoRoute(
        path: '/expense', pageBuilder: (_, s) => _fadePage(ExpenseScreen(), s)),
    GoRoute(
        path: '/operational',
        pageBuilder: (_, s) => _fadePage(OperationalScreen(), s)),
    GoRoute(
        path: '/electricity',
        pageBuilder: (_, s) => _fadePage(ElectricityScreen(), s)),
    GoRoute(
        path: '/project-finance',
        pageBuilder: (_, s) => _fadePage(ProjectFinanceScreen(), s)),

    // ── Project routes ──
    GoRoute(
        path: '/manage-project',
        pageBuilder: (_, s) => _softFadePage(ManageProjectScreen(), s)),
    GoRoute(
        path: '/project-list',
        pageBuilder: (_, s) => _fadePage(ProjectListScreen(), s)),
    GoRoute(
      path: '/project-detail',
      pageBuilder: (_, s) {
        final args = s.extra as Map<String, dynamic>;
        return _fadePage(
          ProjectDetailScreen(
            projectName: args['projectName'] as String,
            workerName: args['workerName'] as String,
          ),
          s,
        );
      },
    ),
    GoRoute(
        path: '/work-order',
        pageBuilder: (_, s) => _fadePage(WorkOrderScreen(), s)),
    GoRoute(
        path: '/meeting', pageBuilder: (_, s) => _fadePage(MeetingScreen(), s)),
    GoRoute(
        path: '/create-meeting',
        pageBuilder: (_, s) => _fadePage(CreateMeetingScreen(), s)),

    // ── Worker routes ──
    GoRoute(
        path: '/worker', pageBuilder: (_, s) => _fadePage(WorkerScreen(), s)),
    GoRoute(
        path: '/worker-list',
        pageBuilder: (_, s) => _fadePage(WorkerListScreen(), s)),
    GoRoute(
      path: '/worker-detail',
      pageBuilder: (_, s) {
        final args = s.extra as Map<String, dynamic>;
        return _fadePage(
          WorkerDetailScreen(
            nama: args['nama'] as String,
            role: args['role'] as String,
            projects: args['projects'] as List<String>,
            avatarAsset: args['avatarAsset'] as String?,
            phone: (args['phone'] as String?) ?? '',
            address: (args['address'] as String?) ?? '',
            notes: (args['notes'] as String?) ?? '',
          ),
          s,
        );
      },
    ),
    GoRoute(path: '/wage', pageBuilder: (_, s) => _fadePage(WageScreen(), s)),
    GoRoute(path: '/wage-schedule', redirect: (_, __) => '/unified-schedule'),
    GoRoute(
        path: '/wage-billing-status',
        pageBuilder: (_, s) => _fadePage(WageBillingStatusScreen(), s)),

    // ── Schedule routes ──
    GoRoute(
        path: '/schedule',
        pageBuilder: (_, s) => _fadePage(UnifiedScheduleScreen(), s)),
    GoRoute(
        path: '/production-schedule', redirect: (_, __) => '/unified-schedule'),
    GoRoute(
        path: '/shopping-schedule', redirect: (_, __) => '/unified-schedule'),
    GoRoute(
        path: '/delivery-schedule', redirect: (_, __) => '/unified-schedule'),
    GoRoute(
        path: '/unified-schedule',
        pageBuilder: (_, s) => _fadePage(const UnifiedScheduleScreen(), s)),

    // ── Inventory routes ──
    GoRoute(
        path: '/raw-material',
        pageBuilder: (_, s) => _softFadePage(RawMaterialScreen(), s)),
    GoRoute(
        path: '/shipment',
        pageBuilder: (_, s) {
          final prevRoute = s.uri.queryParameters['prev'] ?? '/home';
          return _fadePage(ShipmentScreen(prevRoute: prevRoute), s);
        }),
    GoRoute(
        path: '/shipment-detail',
        pageBuilder: (_, s) {
          final prevRoute = s.uri.queryParameters['prev'] ?? '/shipment';
          return _softFadePage(
            ShipmentDetailScreen(
              itemData: s.extra as Object,
              prevRoute: prevRoute,
            ),
            s,
          );
        }),
    GoRoute(
        path: '/shopping-plan',
        pageBuilder: (_, s) => _fadePage(ShoppingPlanScreen(), s)),

    // ── Production ──
    GoRoute(
        path: '/pattern', pageBuilder: (_, s) => _fadePage(PatternScreen(), s)),

    // ── Marketplace ──
    GoRoute(
        path: '/marketplace',
        pageBuilder: (_, s) => _fadePage(MarketplaceScreen(), s)),
    GoRoute(
        path: '/checkout',
        pageBuilder: (_, s) => _fadePage(CheckoutScreen(), s)),
    GoRoute(
      path: '/bookmark-menu',
      pageBuilder: (_, s) {
        final args = s.extra as Map<String, dynamic>;
        return _fadePage(
          BookmarkMenuScreen(
            title: args['title'] as String,
            items: args['items'] as List<BookmarkItem>,
            subtitle: args['subtitle'] as String?,
          ),
          s,
        );
      },
    ),

    // ── Promotion ──
    GoRoute(
        path: '/promotion',
        pageBuilder: (_, s) => _fadePage(PromotionScreen(), s)),

    // ── Common ──
    GoRoute(
      path: '/placeholder',
      pageBuilder: (_, s) {
        final title = s.extra as String? ?? '';
        return _fadePage(SimplePlaceholderPage(title: title), s);
      },
    ),
  ],
);
