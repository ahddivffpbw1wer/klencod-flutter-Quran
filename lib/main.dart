package com.ziko.islamicapp;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.webkit.CookieManager;
import android.webkit.GeolocationPermissions;
import android.webkit.PermissionRequest;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

public class MainActivity extends AppCompatActivity {

    private WebView webView;
    private static final int LOCATION_PERMISSION_REQUEST_CODE = 100;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // إخفاء الشريط العلوي للاستفادة الكاملة من الشاشة
        if (getSupportActionBar() != null) {
            getSupportActionBar().hide();
        }

        webView = new WebView(this);
        setContentView(webView);

        setupWebViewSettings();
        checkLocationPermissions();
    }

    private void setupWebViewSettings() {
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);
        webSettings.setDatabaseEnabled(true);
        webSettings.setLoadsImagesAutomatically(true);
        webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        webSettings.setGeolocationEnabled(true);
        webSettings.setUseWideViewPort(true);
        webSettings.setLoadWithOverviewMode(true);

        // تفعيل ملفات تعريف الارتباط الكوكيز (Cookies)
        CookieManager.getInstance().setAcceptCookie(true);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            CookieManager.getInstance().setAcceptThirdPartyCookies(webView, true);
        }

        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }
        });

        webView.setWebChromeClient(new WebChromeClient() {
            // دعم تحديد الموقع الجغرافي لمواقيت الصلاة الدقيقة
            @Override
            public void onGeolocationPermissionsShowPrompt(String origin, GeolocationPermissions.Callback callback) {
                callback.invoke(origin, true, false);
            }

            // دعم الأذونات الصوتية لتشغيل سور القرآن والمقاطع الخارجية
            @Override
            public void onPermissionRequest(PermissionRequest request) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Lollipop) {
                    request.grant(request.getResources());
                }
            }
        });

        // تحميل كود التطبيق الإسلامي الشامل
        loadIslamicAppHTML();
    }

    private void loadIslamicAppHTML() {
        String htmlContent = "<!DOCTYPE html>\n" +
                "<html lang=\"ar\" dir=\"rtl\" class=\"theme-light\">\n" +
                "<head>\n" +
                "    <meta charset=\"UTF-8\">\n" +
                "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\">\n" +
                "    <title>التطبيق الإسلامي الشامل - ابي المقداد الخوخي</title>\n" +
                "    <script src=\"https://cdn.tailwindcss.com\"></script>\n" +
                "    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css\">\n" +
                "    <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\n" +
                "    <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>\n" +
                "    <link href=\"https://fonts.googleapis.com/css2?family=Amiri:ital,wght@0,400;0,700;1,400&family=Tajawal:wght@300;400;500;700;800&display=swap\" rel=\"stylesheet\">\n" +
                "    <script>\n" +
                "        tailwind.config = {\n" +
                "            theme: {\n" +
                "                extend: {\n" +
                "                    colors: {\n" +
                "                        themeBg: 'var(--bg-main)',\n" +
                "                        themeCard: 'var(--bg-card)',\n" +
                "                        themeText: 'var(--text-main)',\n" +
                "                        themeMuted: 'var(--text-muted)',\n" +
                "                        themeBorder: 'var(--border-color)',\n" +
                "                        themeAccent: 'var(--accent-color)',\n" +
                "                        themePrimary: 'var(--primary-color)',\n" +
                "                    },\n" +
                "                    fontFamily: {\n" +
                "                        tajawal: ['Tajawal', 'sans-serif'],\n" +
                "                        amiri: ['Amiri', 'serif'],\n" +
                "                    }\n" +
                "                }\n" +
                "            }\n" +
                "        }\n" +
                "    </script>\n" +
                "    <style>\n" +
                "        :root.theme-light { --bg-main: #f8f9fa; --bg-card: #ffffff; --text-main: #4a3525; --text-muted: #8c735d; --border-color: #f1c40f; --accent-color: #8b5a2b; --primary-color: #d97706; --card-shadow: 0 4px 20px rgba(139, 90, 43, 0.08); }\n" +
                "        :root.theme-dark { --bg-main: #0b1311; --bg-card: #12211c; --text-main: #f3f4f6; --text-muted: #a3b8b0; --border-color: #d4af37; --accent-color: #e6c280; --primary-color: #d4af37; --card-shadow: 0 4px 20px rgba(0, 0, 0, 0.5); }\n" +
                "        :root.theme-emerald { --bg-main: #f0fdf4; --bg-card: #ffffff; --text-main: #064e3b; --text-muted: #047857; --border-color: #34d399; --accent-color: #059669; --primary-color: #10b981; --card-shadow: 0 4px 20px rgba(6, 78, 59, 0.08); }\n" +
                "        :root.theme-blue { --bg-main: #f0f9ff; --bg-card: #ffffff; --text-main: #0c4a6e; --text-muted: #0369a1; --border-color: #38bdf8; --accent-color: #0284c7; --primary-color: #0284c7; --card-shadow: 0 4px 20px rgba(12, 74, 110, 0.08); }\n" +
                "        body { font-family: 'Tajawal', sans-serif; background-color: var(--bg-main); color: var(--text-main); touch-action: manipulation; -webkit-tap-highlight-color: transparent; transition: background-color 0.3s ease, color 0.3s ease; }\n" +
                "        .quran-font { font-family: 'Amiri', serif; }\n" +
                "        ::-webkit-scrollbar { width: 6px; }\n" +
                "        ::-webkit-scrollbar-thumb { background: var(--primary-color); border-radius: 4px; }\n" +
                "        .app-card { background-color: var(--bg-card); border: 1px solid var(--border-color); box-shadow: var(--card-shadow); }\n" +
                "        .nav-btn.active { color: var(--primary-color); transform: translateY(-2px); }\n" +
                "    </style>\n" +
                "</head>\n" +
                "<body class=\"min-h-screen flex flex-col justify-between pb-24 select-none\">\n" +
                "    <header class=\"sticky top-0 z-40 app-card border-b px-4 py-3 flex items-center justify-between shadow-sm backdrop-blur-md\">\n" +
                "        <div class=\"flex items-center gap-3\">\n" +
                "            <div class=\"w-10 h-10 rounded-full bg-gradient-to-tr from-amber-600 to-yellow-500 flex items-center justify-center text-white font-bold shadow-md\">\n" +
                "                <i class=\"fa-solid fa-kaaba text-lg\"></i>\n" +
                "            </div>\n" +
                "            <div>\n" +
                "                <h1 class=\"font-bold text-lg leading-tight text-themeAccent\">التطبيق الإسلامي</h1>\n" +
                "                <p class=\"text-[11px] text-themeMuted font-medium\">حقوق النشر © ابي المقداد الخوخي</p>\n" +
                "            </div>\n" +
                "        </div>\n" +
                "        <div class=\"flex items-center gap-2\">\n" +
                "            <button onclick=\"toggleThemeMenu()\" class=\"p-2 rounded-xl bg-amber-500/10 text-themeAccent border border-yellow-500/40 text-xs font-semibold\"><i class=\"fa-solid fa-palette\"></i> الألوان</button>\n" +
                "            <button onclick=\"openDeveloperModal()\" class=\"p-2 rounded-xl bg-amber-500/10 text-themeAccent border border-yellow-500/40 text-xs font-semibold\"><i class=\"fa-solid fa-code\"></i> المطور</button>\n" +
                "        </div>\n" +
                "    </header>\n" +
                "    <div id=\"theme-menu\" class=\"hidden fixed top-16 left-4 z-50 app-card rounded-2xl p-3 shadow-2xl border border-yellow-500/30 flex flex-col gap-2 min-w-[170px]\">\n" +
                "        <button onclick=\"setAppTheme('theme-light')\" class=\"p-2 text-xs font-bold text-amber-800 text-right\">النسق الفاتح</button>\n" +
                "        <button onclick=\"setAppTheme('theme-dark')\" class=\"p-2 text-xs font-bold text-gray-200 text-right\">النسق الداكن</button>\n" +
                "        <button onclick=\"setAppTheme('theme-emerald')\" class=\"p-2 text-xs font-bold text-emerald-800 text-right\">النسق الزمردي</button>\n" +
                "        <button onclick=\"setAppTheme('theme-blue')\" class=\"p-2 text-xs font-bold text-sky-800 text-right\">النسق الأزرق</button>\n" +
                "    </div>\n" +
                "    <main id=\"main-content\" class=\"flex-grow p-4 max-w-4xl mx-auto w-full\"></main>\n" +
                "    <div id=\"audio-player-container\" class=\"hidden fixed bottom-16 left-0 right-0 z-40 px-3 py-1\">\n" +
                "        <div class=\"max-w-4xl mx-auto app-card rounded-2xl p-3 shadow-2xl border-2 border-yellow-500 flex flex-col gap-2\">\n" +
                "            <div class=\"flex items-center justify-between\">\n" +
                "                <div>\n" +
                "                    <h4 id=\"audio-surah-title\" class=\"font-bold text-sm text-themeAccent\">اسم المقطع</h4>\n" +
                "                    <p id=\"audio-reciter-title\" class=\"text-xs text-themeMuted\">القارئ</p>\n" +
                "                </div>\n" +
                "                <div class=\"flex items-center gap-3\">\n" +
                "                    <button onclick=\"toggleAudioPlay()\" id=\"audio-play-btn\" class=\"w-10 h-10 rounded-full bg-amber-500 text-white flex items-center justify-center\"><i class=\"fa-solid fa-play\"></i></button>\n" +
                "                    <button onclick=\"closeAudioPlayer()\" class=\"text-red-500\"><i class=\"fa-solid fa-xmark text-lg\"></i></button>\n" +
                "                </div>\n" +
                "            </div>\n" +
                "        </div>\n" +
                "        <audio id=\"global-audio\" class=\"hidden\"></audio>\n" +
                "    </div>\n" +
                "    <nav class=\"fixed bottom-0 left-0 right-0 z-50 app-card border-t py-2 px-2 shadow-lg\">\n" +
                "        <div class=\"max-w-md mx-auto flex justify-around items-center\">\n" +
                "            <button onclick=\"switchTab('home')\" id=\"nav-home\" class=\"nav-btn active flex flex-col items-center gap-1 text-themeMuted text-xs\"><i class=\"fa-solid fa-house text-lg\"><span>الرئيسية</span></i></button>\n" +
                "            <button onclick=\"switchTab('quran')\" id=\"nav-quran\" class=\"nav-btn flex flex-col items-center gap-1 text-themeMuted text-xs\"><i class=\"fa-solid fa-book-quran text-lg\"><span>المصحف</span></i></button>\n" +
                "            <button onclick=\"switchTab('audio')\" id=\"nav-audio\" class=\"nav-btn flex flex-col items-center gap-1 text-themeMuted text-xs\"><i class=\"fa-solid fa-headphones text-lg\"><span>الصوتيات</span></i></button>\n" +
                "            <button onclick=\"switchTab('azkar')\" id=\"nav-azkar\" class=\"nav-btn flex flex-col items-center gap-1 text-themeMuted text-xs\"><i class=\"fa-solid fa-hands-praying text-lg\"><span>الأذكار</span></i></button>\n" +
                "            <button onclick=\"switchTab('tasbeeh')\" id=\"nav-tasbeeh\" class=\"nav-btn flex flex-col items-center gap-1 text-themeMuted text-xs\"><i class=\"fa-solid fa-ring text-lg\"><span>المسبحة</span></i></button>\n" +
                "        </div>\n" +
                "    </nav>\n" +
                "    <div id=\"developer-modal\" class=\"fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden\">\n" +
                "        <div id=\"developer-drawer\" class=\"fixed inset-y-0 right-0 w-full max-w-md app-card p-6 flex flex-col justify-between\">\n" +
                "            <div>\n" +
                "                <div class=\"flex justify-between items-center border-b pb-4 mb-6\">\n" +
                "                    <span class=\"font-bold text-lg text-themeAccent\">قسم المطور</span>\n" +
                "                    <button onclick=\"closeDeveloperModal()\"><i class=\"fa-solid fa-xmark text-lg text-themeAccent\"></i></button>\n" +
                "                </div>\n" +
                "                <div class=\"text-center\">\n" +
                "                    <h3 class=\"text-xl font-extrabold text-themeAccent\">ابي المقداد الخوخي</h3>\n" +
                "                    <p class=\"text-xs text-themeMuted mt-2\">مطور ومصمم تطبيقات إسلامية حديثة.</p>\n" +
                "                </div>\n" +
                "            </div>\n" +
                "        </div>\n" +
                "    </div>\n" +
                "    <script>\n" +
                "        let currentTab = 'home';\n" +
                "        let surahList = [];\n" +
                "        window.onload = function() { fetchSurahList(); switchTab('home'); };\n" +
                "        function setAppTheme(t) { document.documentElement.className = t; document.getElementById('theme-menu').classList.add('hidden'); }\n" +
                "        function toggleThemeMenu() { document.getElementById('theme-menu').classList.toggle('hidden'); }\n" +
                "        function openDeveloperModal() { document.getElementById('developer-modal').classList.remove('hidden'); }\n" +
                "        function closeDeveloperModal() { document.getElementById('developer-modal').classList.add('hidden'); }\n" +
                "        async function fetchSurahList() { try { const res = await fetch('https://api.alquran.cloud/v1/surah'); const d = await res.json(); if(d.code===200) surahList=d.data; } catch(e){} }\n" +
                "        function switchTab(t) {\n" +
                "            currentTab = t;\n" +
                "            const c = document.getElementById('main-content');\n" +
                "            if(t==='home') c.innerHTML = '<div class=\"app-card p-6 rounded-3xl text-center\">\\n<h2 class=\"text-2xl font-black text-themeAccent mb-2\">مرحباً بك في التطبيق الإسلامي</h2>\\n<p class=\"text-xs text-themeMuted\">تطوير وإشراف: ابي المقداد الخوخي</p>\\n</div>';\n" +
                "            else if(t==='quran') c.innerHTML = '<div class=\"text-center py-10\">المصحف الشريف (قيد التحميل...)</div>';\n" +
                "            else if(t==='audio') c.innerHTML = '<div class=\"text-center py-10\">قسم الصوتيات والمرئيات</div>';\n" +
                "            else if(t==='azkar') c.innerHTML = '<div class=\"text-center py-10\">موسوعة الأذكار والادعية</div>';\n" +
                "            else if(t==='tasbeeh') c.innerHTML = '<div class=\"text-center py-10\">المسبحة الرقمية التفاعلية</div>';\n" +
                "        }\n" +
                "    </script>\n" +
                "</body>\n" +
                "</html>";

        webView.loadDataWithBaseURL("https://app.local", htmlContent, "text/html", "UTF-8", null);
    }

    private void checkLocationPermissions() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, LOCATION_PERMISSION_REQUEST_CODE);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(this, "تم تفعيل إذن الموقع الجغرافي بنجاح", Toast.LENGTH_SHORT).show();
            }
        }
    }

    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }
}
