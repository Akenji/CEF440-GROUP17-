import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/services/supabase_service.dart';

class AdminReportsPage extends ConsumerStatefulWidget {
  const AdminReportsPage({super.key});

  @override
  ConsumerState<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends ConsumerState<AdminReportsPage> {
  String _selectedPeriod = 'This Month';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          DropdownButton<String>(
            value: _selectedPeriod,
            items: const [
              DropdownMenuItem(value: 'This Week', child: Text('This Week')),
              DropdownMenuItem(value: 'This Month', child: Text('This Month')),
              DropdownMenuItem(value: 'This Semester', child: Text('This Semester')),
              DropdownMenuItem(value: 'This Year', child: Text('This Year')),
            ],
            onChanged: (value) => setState(() => _selectedPeriod = value!),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Students', '1,234', Icons.people, Colors.blue)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Total Courses', '89', Icons.book, Colors.green)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('Active Sessions', '23', Icons.class_, Colors.orange)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Attendance Rate', '87%', Icons.check_circle, Colors.purple)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Attendance Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance Trends',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: true),
                          titlesData: const FlTitlesData(show: true),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 3),
                                FlSpot(1, 4),
                                FlSpot(2, 3.5),
                                FlSpot(3, 5),
                                FlSpot(4, 4.5),
                                FlSpot(5, 6),
                                FlSpot(6, 5.5),
                              ],
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Department Performance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Department Performance',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDepartmentRow('Computer Science', 92, Colors.blue),
                    _buildDepartmentRow('Mathematics', 88, Colors.green),
                    _buildDepartmentRow('Software Engineering', 85, Colors.orange),
                    _buildDepartmentRow('Physics', 90, Colors.purple),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentRow(String department, int percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(department),
              Text('$percentage%'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}
