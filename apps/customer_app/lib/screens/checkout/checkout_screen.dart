import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  String _paymentMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        children: [
          // Stepper Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StepIndicator(idx: 0, current: _currentStep, label: 'Delivery'),
                _StepDivider(active: _currentStep > 0),
                _StepIndicator(idx: 1, current: _currentStep, label: 'Payment'),
                _StepDivider(active: _currentStep > 1),
                _StepIndicator(idx: 2, current: _currentStep, label: 'Review'),
              ],
            ),
          ),
          
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                _DeliveryStep(),
                _PaymentStep(
                  selected: _paymentMethod,
                  onSelect: (val) => setState(() => _paymentMethod = val),
                ),
                _ReviewStep(),
              ],
            ),
          ),
          
          _BottomAction(
            step: _currentStep,
            onBack: () => setState(() => _currentStep--),
            onNext: () {
              if (_currentStep < 2) {
                setState(() => _currentStep++);
              } else {
                _showSuccess();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showSuccess() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: 100, height: 100,
              decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 64),
            ),
            const SizedBox(height: 32),
            const Text('Order Placed Successfully!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            const Text('Your order #13042599 has been received and is being prepared.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Color(0xFF64748B))),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.main),
                child: const Text('Track My Order'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.offAllNamed(AppRoutes.main),
              child: const Text('Back to Home', style: TextStyle(color: Color(0xFF94A3B8))),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int idx;
  final int current;
  final String label;
  const _StepIndicator({required this.idx, required this.current, required this.label});

  @override
  Widget build(BuildContext context) {
    final active = idx <= current;
    return Column(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFF97316) : const Color(0xFFE2E8F0),
            shape: BoxShape.circle,
            border: Border.all(color: active ? const Color(0xFFF97316) : Colors.transparent, width: 2),
          ),
          child: Center(
            child: idx < current 
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text('${idx + 1}', style: TextStyle(color: active ? Colors.white : const Color(0xFF94A3B8), fontWeight: FontWeight.w800, fontSize: 13)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: active ? const Color(0xFF1E293B) : const Color(0xFF94A3B8))),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  final bool active;
  const _StepDivider({required this.active});
  @override
  Widget build(BuildContext context) {
    return Container(width: 40, height: 2, margin: const EdgeInsets.symmetric(horizontal: 4, marginBottom: 16), color: active ? const Color(0xFFF97316) : const Color(0xFFE2E8F0));
  }
}

class _DeliveryStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF97316)),
          ),
          child: Row(
            children: [
              const Icon(Icons.home_rounded, color: Color(0xFFF97316)),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Home', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  Text('123 Main Street, Apt 4B, New York, NY', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                ]),
              ),
              TextButton(onPressed: () {}, child: const Text('Change', style: TextStyle(color: Color(0xFFF97316), fontWeight: FontWeight.w700))),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text('Delivery Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        Row(
          children: [
            _TimeOption(label: 'ASAP', time: '30-40 min', selected: true),
            const SizedBox(width: 12),
            _TimeOption(label: 'Schedule', time: 'Later', selected: false),
          ],
        ),
      ],
    );
  }
}

class _TimeOption extends StatelessWidget {
  final String label;
  final String time;
  final bool selected;
  const _TimeOption({required this.label, required this.time, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF7ED) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? const Color(0xFFF97316) : const Color(0xFFE2E8F0)),
        ),
        child: Column(children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: selected ? const Color(0xFF1E293B) : const Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(time, style: TextStyle(fontSize: 11, color: selected ? const Color(0xFFF97316) : const Color(0xFF94A3B8))),
        ]),
      ),
    );
  }
}

class _PaymentStep extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;
  const _PaymentStep({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        _PayTile(id: 'cash', label: 'Cash on Delivery', icon: Icons.money_rounded, selected: selected == 'cash', onSelect: onSelect),
        _PayTile(id: 'card', label: 'Credit / Debit Card', icon: Icons.credit_card_rounded, selected: selected == 'card', onSelect: onSelect),
        _PayTile(id: 'paypal', label: 'PayPal', icon: Icons.account_balance_wallet_rounded, selected: selected == 'paypal', onSelect: onSelect),
      ],
    );
  }
}

class _PayTile extends StatelessWidget {
  final String id;
  final String label;
  final IconData icon;
  final bool selected;
  final Function(String) onSelect;
  const _PayTile({required this.id, required this.label, required this.icon, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF7ED) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? const Color(0xFFF97316) : const Color(0xFFE2E8F0)),
        ),
        child: Row(children: [
          Icon(icon, color: selected ? const Color(0xFFF97316) : const Color(0xFF94A3B8)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const Spacer(),
          if (selected) const Icon(Icons.check_circle_rounded, color: Color(0xFFF97316), size: 20),
        ]),
      ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Order Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFF1F5F9))),
          child: const Column(children: [
            _ReviewRow(label: 'Items (3)', value: '\$33.48'),
            _ReviewRow(label: 'Delivery', value: 'FREE'),
            _ReviewRow(label: 'Tax', value: '\$2.68'),
            Divider(height: 32),
            _ReviewRow(label: 'Total Amount', value: '\$36.16', isBold: true),
          ]),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _ReviewRow({required this.label, required this.value, this.isBold = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: isBold ? const Color(0xFF1E293B) : const Color(0xFF64748B), fontWeight: isBold ? FontWeight.w800 : FontWeight.w500)),
        Text(value, style: TextStyle(color: isBold ? const Color(0xFFF97316) : const Color(0xFF1E293B), fontWeight: isBold ? FontWeight.w900 : FontWeight.w700, fontSize: isBold ? 18 : 14)),
      ]),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final int step;
  final VoidCallback onBack;
  final VoidCallback onNext;
  const _BottomAction({required this.step, required this.onBack, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(32)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -4))]),
      child: SafeArea(
        child: Row(children: [
          if (step > 0) ...[
            Expanded(child: OutlinedButton(onPressed: onBack, style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(vertical: 14)), child: const Text('Back', style: TextStyle(color: Color(0xFF64748B))))),
            const SizedBox(width: 16),
          ],
          Expanded(flex: 2, child: ElevatedButton(onPressed: onNext, child: Text(step == 2 ? 'Place Order' : 'Continue'))),
        ]),
      ),
    );
  }
}
