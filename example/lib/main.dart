import 'package:flutter/material.dart';
import 'package:imperial_persian_date/imperial_persian_date.dart';

void main() {
  runApp(const ImperialPersianDateExampleApp());
}

class ImperialPersianDateExampleApp extends StatelessWidget {
  const ImperialPersianDateExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imperial Persian Date Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ImperialPersianDate _today;
  late final List<_DemoItem> _demoItems;
  final TextEditingController _dateController = TextEditingController();
  ImperialPersianDate? _selectedImperialDate;

  @override
  void initState() {
    super.initState();
    _today = ImperialPersianDate.now();
    _demoItems = _buildDemoItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Rebuild demo items when dependencies change
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedImperialDate = ImperialPersianDate.fromGregorian(picked);
        _dateController.text = _selectedImperialDate!.format('YYYY/MM/DD');
      });
    }
  }

  List<_DemoItem> _buildDemoItems() {
    // ------------------------------------------------------------------ today
    final today = ImperialPersianDate.now();
    final gregToday = DateTime.now();

    // -------------------------------------------------- specific date examples
    final independence = ImperialPersianDate.fromGregorian(
      DateTime(1979, 2, 11),
    ); // 22 Bahman 1357 Shamsi → 2537 Imperial

    final fromShamsi = ImperialPersianDate.fromShamsi(1403, 12, 1);

    // ------------------------------------------------------- arithmetic
    final nextMonth = today.addMonths(1);
    final lastYear = today.addYears(-1);
    final inTenDays = today.addDays(10);

    // ------------------------------------------------------- difference
    final epoch = ImperialPersianDate(2500, 1, 1);
    final diffDays = today.difference(epoch);

    // ------------------------------------------------------- copyWith
    final copied = today.copyWith(hour: 12, minute: 30, second: 0);

    // ------------------------------------------------------- Shamsi round-trip
    final shamsi = today.toShamsi();
    final roundTrip = ImperialPersianDate.fromShamsi(
      shamsi[0],
      shamsi[1],
      shamsi[2],
    );

    // ------------------------------------------------------- leap year
    final leapImperial = ImperialPersianDate(2583, 1, 1); // example year

    return [
      _DemoItem(
        title: 'Today (Imperial Persian)',
        icon: Icons.today,
        content: today.toString(),
        detail: 'format("YYYY/MM/DD"): ${today.format("YYYY/MM/DD")}',
      ),
      _DemoItem(
        title: 'Today – full Persian format',
        icon: Icons.calendar_month,
        content: today.format('WWWW DD MMMM YYYY'),
        detail: 'Weekday (EN): ${today.weekDayNameEn}',
      ),
      _DemoItem(
        title: 'Today – English month name',
        icon: Icons.calendar_today,
        content: today.format('DD MMME YYYY'),
        detail:
            'Month (FA): ${today.monthName}  |  Month (EN): ${today.monthNameEn}',
      ),
      _DemoItem(
        title: 'Gregorian → Imperial Persian',
        icon: Icons.swap_horiz,
        content:
            'Greg: ${gregToday.year}/${gregToday.month}/${gregToday.day}'
            '  →  Imperial: $today',
        detail: '',
      ),
      _DemoItem(
        title: 'fromGregorian – 11 Feb 1979',
        icon: Icons.history,
        content: independence.toString(),
        detail: independence.format('DD MMMM YYYY (WWWW)'),
      ),
      _DemoItem(
        title: 'fromShamsi – 1 Esfand 1403',
        icon: Icons.transform,
        content: fromShamsi.toString(),
        detail:
            'Shamsi: 1403/12/01  →  Imperial: ${fromShamsi.year}/${fromShamsi.month}/${fromShamsi.day}',
      ),
      _DemoItem(
        title: 'toShamsi()',
        icon: Icons.arrow_circle_right,
        content:
            'Imperial ${today.year}/${today.month}/${today.day}'
            '  →  Shamsi ${shamsi[0]}/${shamsi[1]}/${shamsi[2]}',
        detail:
            'Difference (offset): ${today.year - shamsi[0]} (should be 1180)',
      ),
      _DemoItem(
        title: 'Shamsi round-trip',
        icon: Icons.loop,
        content:
            'fromShamsi(toShamsi()) == today? '
            '${roundTrip == today}',
        detail: roundTrip.toString(),
      ),
      _DemoItem(
        title: 'addMonths(1)',
        icon: Icons.arrow_forward,
        content: nextMonth.toString(),
        detail: 'From: $today',
      ),
      _DemoItem(
        title: 'addYears(-1)',
        icon: Icons.history_toggle_off,
        content: lastYear.toString(),
        detail: 'From: $today',
      ),
      _DemoItem(
        title: 'addDays(10)',
        icon: Icons.add_circle_outline,
        content: inTenDays.toString(),
        detail: 'From: $today',
      ),
      _DemoItem(
        title: 'difference() from epoch 2500/1/1',
        icon: Icons.timeline,
        content: '$diffDays days',
        detail: 'Epoch: $epoch',
      ),
      _DemoItem(
        title: 'copyWith(hour: 12, minute: 30)',
        icon: Icons.edit_calendar,
        content: copied.toString(),
        detail:
            'HH:mm:ss  ${copied.hour}:${copied.minute.toString().padLeft(2, '0')}:${copied.second.toString().padLeft(2, '0')}',
      ),
      _DemoItem(
        title: 'isLeapYear() – ${leapImperial.year}',
        icon: Icons.check_circle_outline,
        content: '${leapImperial.year} is leap: ${leapImperial.isLeapYear()}',
        detail:
            'Shamsi ${leapImperial.year - ImperialPersianDate.imperialOffset}',
      ),
      _DemoItem(
        title: 'isBefore / isAfter',
        icon: Icons.compare_arrows,
        content:
            'epoch before today? ${epoch.isBefore(today)}'
            '\ntoday after epoch? ${today.isAfter(epoch)}',
        detail: '',
      ),
      _DemoItem(
        title: 'toGregorian()',
        icon: Icons.public,
        content: () {
          final g = today.toGregorian();
          return 'Imperial $today  →  Greg ${g.year}/${g.month}/${g.day}';
        }(),
        detail: '',
      ),
      _DemoItem(
        title: 'Custom format with time',
        icon: Icons.access_time,
        content: copied.format('YYYY/MM/DD HH:mm:ss'),
        detail: 'Pattern: YYYY/MM/DD HH:mm:ss',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Imperial Persian Date'),
            Text(
              _today.format('WWWW DD MMMM YYYY'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Input Field Example',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Imperial Date',
                        hintText: 'Select a date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () => _pickDate(context),
                        ),
                      ),
                      onTap: () => _pickDate(context),
                    ),
                    if (_selectedImperialDate != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedImperialDate!.format(
                                  'WWWW DD MMMM YYYY',
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1, indent: 24, endIndent: 24),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _demoItems.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _demoItems[index];
                return _DemoCard(item: item, index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget helpers
// ---------------------------------------------------------------------------

class _DemoItem {
  final String title;
  final IconData icon;
  final String content;
  final String detail;

  const _DemoItem({
    required this.title,
    required this.icon,
    required this.content,
    required this.detail,
  });
}

class _DemoCard extends StatelessWidget {
  final _DemoItem item;
  final int index;

  const _DemoCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = [
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
    ];
    final bgColor = colors[index % colors.length];

    return Card(
      color: bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, color: colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (item.detail.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.detail,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
