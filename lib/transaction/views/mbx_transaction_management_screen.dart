import 'package:mbankingbackoffice/transaction/controllers/mbx_transaction_controller.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxTransactionManagementScreen extends StatelessWidget {
  const MbxTransactionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MbxTransactionController>(
      init: MbxTransactionController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 700;

              return Row(
                children: [
                  if (!isMobile) _buildSidebar(controller),
                  Expanded(
                    child: Column(
                      children: [
                        _buildTopBar(controller, isMobile),
                        Expanded(
                          child: _buildMainContent(controller, constraints),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSidebar(MbxTransactionController controller) {
    return Container(
      width: 250,
      color: ColorX.theme,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'MBanking Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isActive: false,
                  onTap: () => Get.toNamed('/home'),
                ),
                _buildSidebarItem(
                  icon: Icons.admin_panel_settings,
                  title: 'Admin Management',
                  isActive: false,
                  onTap: () => Get.toNamed('/admin-management'),
                ),
                _buildSidebarItem(
                  icon: Icons.people,
                  title: 'User Management',
                  isActive: false,
                  onTap: () => Get.toNamed('/user-management'),
                ),
                _buildSidebarItem(
                  icon: Icons.receipt_long,
                  title: 'Transaction Management',
                  isActive: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 20),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        onTap: onTap,
        dense: true,
      ),
    );
  }

  Widget _buildTopBar(MbxTransactionController controller, bool isMobile) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isMobile) ...[
            IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            const SizedBox(width: 8),
          ],
          const Text(
            'Transaction Management',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            onPressed: controller.refreshTransactions,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    MbxTransactionController controller,
    BoxConstraints constraints,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFiltersSection(controller, constraints),
          const SizedBox(height: 16),
          _buildStatsCards(controller, constraints),
          const SizedBox(height: 16),
          Expanded(child: _buildTransactionTable(controller, constraints)),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(
    MbxTransactionController controller,
    BoxConstraints constraints,
  ) {
    final isMobile = constraints.maxWidth < 700;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (isMobile)
              _buildMobileFilters(controller)
            else
              _buildDesktopFilters(controller),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: controller.clearFilters,
                  child: const Text('Clear Filters'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: controller.applyFilters,
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileFilters(MbxTransactionController controller) {
    return Column(
      children: [
        TextFieldX(
          hint: 'User ID',
          controller: controller.userIdController,
          keyboardType: TextInputType.text,
          readOnly: false,
          obscureText: false,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: controller.selectedType,
          decoration: const InputDecoration(
            labelText: 'Transaction Type',
            border: OutlineInputBorder(),
          ),
          items: controller.types.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.isEmpty ? 'All Types' : type.toUpperCase()),
            );
          }).toList(),
          onChanged: (value) {
            controller.selectedType = value!;
            controller.update();
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: controller.selectedStatus,
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
          ),
          items: controller.statuses.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(
                status.isEmpty ? 'All Statuses' : status.toUpperCase(),
              ),
            );
          }).toList(),
          onChanged: (value) {
            controller.selectedStatus = value!;
            controller.update();
          },
        ),
      ],
    );
  }

  Widget _buildDesktopFilters(MbxTransactionController controller) {
    return Row(
      children: [
        Expanded(
          child: TextFieldX(
            hint: 'User ID',
            controller: controller.userIdController,
            keyboardType: TextInputType.text,
            readOnly: false,
            obscureText: false,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: controller.selectedType,
            decoration: const InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
            items: controller.types.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.isEmpty ? 'All Types' : type.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              controller.selectedType = value!;
              controller.update();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: controller.selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: controller.statuses.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(
                  status.isEmpty ? 'All Statuses' : status.toUpperCase(),
                ),
              );
            }).toList(),
            onChanged: (value) {
              controller.selectedStatus = value!;
              controller.update();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(
    MbxTransactionController controller,
    BoxConstraints constraints,
  ) {
    final isMobile = constraints.maxWidth < 700;

    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Total Transactions',
              value: controller.totalTransactions.value.toString(),
              icon: Icons.receipt_long,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: 'Current Page',
              value:
                  '${controller.currentPage.value} / ${controller.totalPages.value}',
              icon: Icons.pages,
              color: Colors.green,
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Per Page',
                value: controller.perPage.value.toString(),
                icon: Icons.view_list,
                color: Colors.orange,
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTable(
    MbxTransactionController controller,
    BoxConstraints constraints,
  ) {
    return Obx(() {
      return Card(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Transactions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    'Showing ${controller.transactions.length} of ${controller.totalTransactions.value} transactions',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.transactions.isEmpty
                  ? const Center(
                      child: Text(
                        'No transactions found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth - 32,
                        ),
                        child: DataTable(
                          columnSpacing: 12,
                          horizontalMargin: 16,
                          columns: const [
                            DataColumn(label: Text('Transaction ID')),
                            DataColumn(label: Text('Type')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('User')),
                            DataColumn(label: Text('Account')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: controller.transactions.map((transaction) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 100,
                                    ),
                                    child: Text(
                                      transaction.id,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(transaction.type),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      transaction.displayType,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    transaction.formattedAmount,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        transaction.status,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      transaction.displayStatus,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 120,
                                    ),
                                    child: Text(
                                      transaction.userName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    transaction.maskedAccountNumber,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    transaction.formattedCreatedAt,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => controller
                                            .viewTransaction(transaction),
                                        icon: const Icon(
                                          Icons.visibility,
                                          size: 16,
                                        ),
                                        tooltip: 'View Details',
                                      ),
                                      if (!transaction.isReversed &&
                                          transaction.status == 'completed')
                                        IconButton(
                                          onPressed: () => controller
                                              .showReversalDialog(transaction),
                                          icon: const Icon(
                                            Icons.undo,
                                            size: 16,
                                          ),
                                          tooltip: 'Reverse Transaction',
                                          color: Colors.red,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
            if (controller.totalPages.value > 1) _buildPagination(controller),
          ],
        ),
      );
    });
  }

  Widget _buildPagination(MbxTransactionController controller) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: controller.currentPage.value > 1
                      ? controller.previousPage
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      controller.currentPage.value < controller.totalPages.value
                      ? controller.nextPage
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorX.theme,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'topup':
        return Colors.green;
      case 'withdraw':
        return Colors.orange;
      case 'transfer':
        return Colors.blue;
      case 'reversal':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      case 'reversed':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
