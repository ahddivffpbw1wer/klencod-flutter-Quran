import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';
import 'pages/home_page.dart';
import 'pages/quran_page.dart';
import 'pages/saved_page.dart';
import 'pages/settings_page.dart';
import 'services/storage_service.dart';
import 'services/quran_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const QuranApp());
}

class QuranApp extends StatefulWidget {
  const QuranApp({Key? key}) : super(key: key);

  @override
  State<QuranApp> createState() => QuranAppState();
}

class QuranAppState extends State<QuranApp> {
  ThemeMode themeMode = ThemeMode.light;
  double quranFontSize = 26.0;
  String selectedFontFamily = 'Amiri'; // الخط الافتراضي للمخطوطة القرآنية

  @override
  void initState() {
    super.initState();
    themeMode = StorageService.getThemeMode();
    quranFontSize = StorageService.getQuranFontSize();
  }

  void toggleTheme() {
    setState(() {
      themeMode =
          themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    StorageService.setThemeMode(themeMode);
  }

  void setQuranFontSize(double size) {
    setState(() => quranFontSize = size);
    StorageService.setQuranFontSize(size);
  }

  void setQuranFontFamily(String font) {
    setState(() {
      selectedFontFamily = font;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رفيق القرآن',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const SplashDownloadPage(),
    );
  }
}

// ============================================================
// شاشة التحميل الأولى
// ============================================================
class SplashDownloadPage extends StatefulWidget {
  const SplashDownloadPage({Key? key}) : super(key: key);

  @override
  State<SplashDownloadPage> createState() => _SplashDownloadPageState();
}

class _SplashDownloadPageState extends State<SplashDownloadPage> {
  bool _checking = true;
  bool _downloading = false;
  bool _error = false;
  int _current = 0;
  int _total = 114;
  String _surahName = '';

  @override
  void initState() {
    super.initState();
    _checkAndDownload();
  }

  Future<void> _checkAndDownload() async {
    setState(() {
      _checking = true;
      _error = false;
    });

    if (StorageService.isFullQuranReady()) {
      if (!mounted) return;
      _goToApp();
      return;
    }

    if (!mounted) return;
    setState(() {
      _checking = false;
      _downloading = true;
    });

    await _downloadQuran();
  }

  Future<void> _downloadQuran() async {
    try {
      final fullQuran = await QuranApi.fetchFullQuran(
        onProgress: (current, total, surahName) {
          if (!mounted) return;
          setState(() {
            _current = current;
            _total = total;
            _surahName = surahName.replaceAll('سُورَةُ ', '');
          });
        },
      );

      try {
        final surahs = await QuranApi.fetchSurahs();
        await StorageService.saveSurahsCache(surahs);
      } catch (_) {}

      await StorageService.saveFullQuran(fullQuran);

      if (!mounted) return;
      _goToApp();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _downloading = false;
        _error = true;
      });
    }
  }

  void _goToApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShellPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [scheme.primary, scheme.primary.withOpacity(.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withOpacity(.3),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 64,
                    color: scheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'رفيق القرآن',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'رفيقك اليومي مع كتاب الله',
                  style: TextStyle(
                    fontSize: 14,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 48),
                if (_checking) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('جارٍ التحقق من البيانات...'),
                ] else if (_downloading) ...[
                  Text(
                    'جارٍ تحضير المصحف',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _surahName.isNotEmpty
                        ? 'سورة $_surahName'
                        : 'جارٍ التحميل...',
                    style: TextStyle(
                      fontSize: 13,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: LinearProgressIndicator(
                      value: _total > 0 ? _current / _total : 0,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$_current من $_total سورة (${_total > 0 ? ((_current / _total) * 100).toStringAsFixed(0) : 0}%)',
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else if (_error) ...[
                  Icon(Icons.error_outline_rounded,
                      size: 64, color: scheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'تعذر تحميل المصحف',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _checkAndDownload,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// الواجهة الرئيسية مع قسم المطور وزر الألوان والخطوط
// ============================================================
class MainShellPage extends StatefulWidget {
  const MainShellPage({Key? key}) : super(key: key);

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;
  ThemeMode _themeMode = ThemeMode.light;
  double _quranFontSize = 26.0;
  String _currentFont = 'Uthmanic';

  // قائمة خطوط ومخطوطات
  final List<Map<String, String>> _quranFonts = [
    {'name': 'المخطوطة العثمانية الأصلية', 'font': 'Uthmanic'},
    {'name': 'خط حفص عن عاصم', 'font': 'Hafs'},
    {'name': 'خط الأميري القرآني', 'font': 'Amiri'},
    {'name': 'خط الرقعة الرقمي', 'font': 'Ruqaa'},
    {'name': 'خط النسخ الواضح', 'font': 'Naskh'},
    {'name': 'الخط الكوفي العريق', 'font': 'Kufi'},
    {'name': 'المخطوطة المغربية', 'font': 'Maghrebi'},
  ];

  @override
  void initState() {
    super.initState();
    _themeMode = StorageService.getThemeMode();
    _quranFontSize = StorageService.getQuranFontSize();
  }

  void _toggleTheme() {
    final appState = context.findAncestorStateOfType<QuranAppState>();
    if (appState != null) {
      appState.toggleTheme();
      setState(() {
        _themeMode = appState.themeMode;
      });
    }
  }

  void _setQuranFontSize(double size) {
    final appState = context.findAncestorStateOfType<QuranAppState>();
    if (appState != null) {
      appState.setQuranFontSize(size);
    }
    setState(() => _quranFontSize = size);
  }

  Future<void> _openUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر فتح الرابط: $urlString')),
      );
    }
  }

  // نافذة اختيار المخطوطة/الخط
  void _showFontSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'اختر خط/مخطوطة المصحف',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _quranFonts.length,
                    itemBuilder: (context, index) {
                      final item = _quranFonts[index];
                      final isSelected = item['font'] == _currentFont;
                      return ListTile(
                        leading: Icon(
                          Icons.font_download_rounded,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        title: Text(item['name']!),
                        trailing: isSelected
                            ? Icon(Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary)
                            : null,
                        onTap: () {
                          setState(() {
                            _currentFont = item['font']!;
                          });
                          final appState = context
                              .findAncestorStateOfType<QuranAppState>();
                          appState?.setQuranFontFamily(_currentFont);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('رفيق القرآن'),
          centerTitle: true,
          actions: [
            // زر تغيير المخطوطة/الخط
            IconButton(
              icon: const Icon(Icons.text_fields_rounded),
              tooltip: 'تغيير خط المخطوطة',
              onPressed: _showFontSelector,
            ),
            // زر اللون / الوضع الليلي والنهاري
            IconButton(
              icon: Icon(
                _themeMode == ThemeMode.dark
                    ? Icons.wb_sunny_rounded
                    : Icons.nightlight_round,
              ),
              tooltip: 'تغيير الثيم / الألوان',
              onPressed: _toggleTheme,
            ),
          ],
          leading: Builder(
            builder: (context) => IconButton(
              icon: CircleAvatar(
                radius: 14,
                backgroundColor: scheme.primary.withOpacity(0.2),
                child: Icon(Icons.code_rounded, size: 18, color: scheme.primary),
              ),
              tooltip: 'قسم المطور',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),

        // ==========================================
        // قسم المطور (القائمة الجانبية Drawer الطويلة)
        // ==========================================
        drawer: Drawer(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [scheme.primary, scheme.tertiary],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    radius: 36,
                    backgroundImage: const NetworkImage(
                      'https://i.ibb.co/q3z26DWm/image.png',
                    ),
                    backgroundColor: scheme.surface,
                  ),
                  accountName: const Text(
                    'زيكو الأسطورة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: const Text(
                    'مطور التطبيق والحلول البرمجية',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        child: Text('تواصل ومعلومات المطور'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.chat_outlined,
                            color: Colors.green),
                        title: const Text('واتساب المطور'),
                        subtitle: const Text('967771620853+'),
                        onTap: () => _openUrl('https://wa.me/967771620853'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.campaign_outlined,
                            color: Colors.green),
                        title: const Text('قناة الواتساب الرسمية'),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                        onTap: () => _openUrl(
                            'https://whatsapp.com/channel/0029VbDPwPz3GJP3uEUAOf17'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.telegram_rounded,
                            color: Colors.blue),
                        title: const Text('قناة التليجرام العامة'),
                        subtitle: const Text('@W_78_22'),
                        onTap: () => _openUrl('https://t.me/W_78_22'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.telegram_rounded,
                            color: Colors.blue),
                        title: const Text('قناة التليجرام الرئيسية'),
                        subtitle: const Text('@W_78_23'),
                        onTap: () => _openUrl('https://t.me/W_78_23'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.telegram_rounded,
                            color: Colors.blue),
                        title: const Text('قناة البرمجيات والتطبيقات'),
                        subtitle: const Text('@ZCQ2_g'),
                        onTap: () => _openUrl('https://t.me/ZCQ2_g'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.telegram_rounded,
                            color: Colors.blue),
                        title: const Text('قناة الدعم والملاحظات'),
                        subtitle: const Text('@ABO_SB'),
                        onTap: () => _openUrl('https://t.me/ABO_SB'),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: scheme.surfaceVariant.withOpacity(0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.copyright_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'جميع الحقوق محفوظة © زيكو الأسطورة',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        body: IndexedStack(
          index: _index,
          children: [
            HomePage(onGoToQuran: () => setState(() => _index = 1)),
            QuranPage(quranFontSize: _quranFontSize),
            const SavedPage(),
            SettingsPage(
              isDarkMode: _themeMode == ThemeMode.dark,
              onThemeChanged: _toggleTheme,
              quranFontSize: _quranFontSize,
              onQuranFontSizeChanged: _setQuranFontSize,
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'المصحف',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline_rounded),
              selectedIcon: Icon(Icons.bookmark_rounded),
              label: 'المحفوظات',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}
