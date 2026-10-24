import 'package:flutter/material.dart';

void main() {
  runApp(const MarketingApp());
}

class MarketingApp extends StatelessWidget {
  const MarketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق التسويق الذكي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Cairo', // يمكنك استبداله بأي خط متوفر لديك
      ),
      // دعم اللغة العربية والاتجاه من اليمين لليسار
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}

// نموذج البيانات (Product Model)
class Product {
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;
  final double rating;

  Product({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // قائمة وهمية للمنتجات أو العروض التسويقية
  final List<Product> products = const [
    Product(
      title: 'باقة التسويق الرقمي الشاملة',
      subtitle: 'إعلانات ممولة + إدارة صفحات',
      price: '\$299',
      imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=500',
      rating: 4.8,
    ),
    Product(
      title: 'تصميم هوية بصرية متكاملة',
      subtitle: 'شعار، ألوان، ومطبوعات',
      price: '\$150',
      imageUrl: 'https://images.unsplash.com/photo-1542744094-3a31f272c490?w=500',
      rating: 4.9,
    ),
    Product(
      title: 'استراتيجية تحسين محركات البحث SEO',
      subtitle: 'تصدر نتائج جوجل الأولى',
      price: '\$200',
      imageUrl: 'https://images.unsplash.com/photo-1533750349077-cdcd1ec51543?w=500',
      rating: 4.7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منصة التسويق الذكي', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسم البانر الإعلاني (Banner)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'عروض حصرية لفترة محدودة! 🔥',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'احصل على خصم 30% على خدمات التسويق',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Chip(
                      label: Text('اطلب الخدمة الآن', style: TextStyle(color: Colors.deepPurple)),
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // الأقسام (Categories)
              const Text(
                'الأقسام التسويقية',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CategoryItem(icon: Icons.campaign, title: 'إعلانات ممولة'),
                    CategoryItem(icon: Icons.brush, title: 'تصميم وبصريات'),
                    CategoryItem(icon: Icons.trending_up, title: 'خدمات SEO'),
                    CategoryItem(icon: Icons.code, title: 'تطوير مواقع'),
                    CategoryItem(icon: Icons.chat, title: 'إدارة محتوى'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // قائمة الخدمات / المنتجات المميزة
              const Text(
                'الخدمات المميزة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.imageUrl,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.subtitle,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product.price,
                                      style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 16),
                                        const SizedBox(width: 4),
                                        Text('${product.rating}', style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'استكشف'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

// عنصر القسم الأفقي
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const CategoryItem({super.key, required this.icon, required this.title});

  @override
  Widget build(Context context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(left: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
