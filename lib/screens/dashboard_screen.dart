import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../models/item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock Data for now
  final Budget currentBudget = Budget(id: '1', totalBudget: 5000, spent: 3250);
  
  final List<Item> inventory = [
    Item(id: '1', name: 'Milk', quantity: 1, minQuantity: 2, price: 5.0),
    Item(id: '2', name: 'Eggs', quantity: 12, minQuantity: 6, price: 3.5),
    Item(id: '3', name: 'Bread', quantity: 0, minQuantity: 1, price: 2.0),
    Item(id: '4', name: 'Coffee Beans', quantity: 3, minQuantity: 1, price: 15.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Slate dark mode bg
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Zad',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildBudgetCard(),
              const SizedBox(height: 30),
              const Text(
                'Inventory Alerts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(child: _buildInventoryList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Open camera logic here
        },
        backgroundColor: const Color(0xFF4F46E5), // Indigo Accent
        icon: const Icon(Icons.document_scanner_outlined, color: Colors.white),
        label: const Text('AI Scan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBudgetCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Slate 800
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF334155), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Remaining Budget',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'This Month',
                  style: TextStyle(color: Color(0xFF818CF8), fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '\$${currentBudget.remaining.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: currentBudget.spentPercentage,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF818CF8), Color(0xFF4F46E5)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withOpacity(0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: \$${currentBudget.spent.toStringAsFixed(0)}',
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
              Text(
                'Total: \$${currentBudget.totalBudget.toStringAsFixed(0)}',
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    return ListView.separated(
      itemCount: inventory.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = inventory[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isLowStock 
                ? const Color(0xFFEF4444).withOpacity(0.5) 
                : const Color(0xFF334155),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.isLowStock
                      ? const Color(0xFFEF4444).withOpacity(0.1)
                      : const Color(0xFF334155).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.isLowStock ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
                  color: item.isLowStock ? const Color(0xFFF87171) : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty: ${item.quantity} (Min: ${item.minQuantity})',
                      style: TextStyle(
                        color: item.isLowStock ? const Color(0xFFF87171) : const Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.isLowStock)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Low Stock',
                    style: TextStyle(
                      color: Color(0xFFF87171),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
