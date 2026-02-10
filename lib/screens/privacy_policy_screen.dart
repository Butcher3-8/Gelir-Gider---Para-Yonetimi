import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gizlilik Politikası'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _PolicySection(
            title: '1) Toplanan Veriler',
            content:
                'Uygulama; gelir-gider kayıtları, kategori bilgileri ve uygulama ayarları gibi '
                'kullanıcının girdiği verileri işler.',
          ),
          _PolicySection(
            title: '2) Verilerin Saklanması',
            content:
                'Veriler cihazınızda yerel olarak saklanır. Uygulama verileri otomatik olarak '
                'herhangi bir sunucuya göndermez.',
          ),
          _PolicySection(
            title: '3) Yedekleme İşlemleri',
            content:
                'Dışa aktarma ve içe aktarma işlemleri sadece kullanıcı isteğiyle yapılır. '
                'Yedek dosyası kullanıcı tarafından seçilen konuma kaydedilir veya o konumdan okunur.',
          ),
          _PolicySection(
            title: '4) Üçüncü Taraf Servisler',
            content:
                'Uygulama, kişisel finans verilerinizi paylaşmak amacıyla üçüncü taraf analitik veya '
                'reklam servisleri kullanmaz.',
          ),
          _PolicySection(
            title: '5) İletişim',
            content:
                'Gizlilikle ilgili sorularınız için geliştirici ile mağaza sayfasında belirtilen '
                'iletişim kanallarından iletişime geçebilirsiniz.',
          ),
          SizedBox(height: 8),
          Text(
            'Son güncelleme: Şubat 2026',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const _PolicySection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
