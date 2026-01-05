import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/spent_controller.dart';
import '../app_colors.dart';
import '../widgets/snack_bar.dart';

class SpentView extends StatelessWidget {
  const SpentView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpentController>(
      init: SpentController(),
      builder: (controller) {
        final now = DateTime.now();

        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.secondaryColor,
            foregroundColor: AppColors.white,
            title: const Text(
              'Add Expense',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {},
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Date Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('MMMM dd, yyyy').format(now),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('EEEE').format(now),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.calendar_month,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔹 Expense Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isSmallScreen = constraints.maxWidth < 600;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/money.svg',
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.secondaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Expense Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // 🔹 Member + Category (RESPONSIVE)
                            if (isSmallScreen) ...[
                              _memberDropdown(controller),
                              const SizedBox(height: 16),
                              _categoryDropdown(controller),
                            ] else
                              Row(
                                children: [
                                  Expanded(child: _memberDropdown(controller)),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _categoryDropdown(controller),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 20),

                            // 🔹 Amount
                            TextFormField(
                              controller: controller.amountController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(
                                label: 'Amount Spent',
                                child: SvgPicture.asset(
                                  'assets/images/money.svg',
                                  width: 10,
                                  height: 10,
                      
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // 🔹 Submit
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: controller.submitExpense,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondaryColor,
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Submit Expense',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔹 MEMBER DROPDOWN
  Widget _memberDropdown(SpentController controller) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: _inputDecoration(
        label: 'Member',
        child: SvgPicture.asset(
          'assets/images/room.svg',
          width: 10,
          height: 10,
        ),
      ),
      value: controller.selectedMember,
      items: controller.members
          .map(
            (member) => DropdownMenuItem<String>(
              value: member,
              child: Text(member, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (value) {
        controller.selectedMember = value;
        controller.update();
      },
    );
  }

  // 🔹 CATEGORY DROPDOWN (FIXED OVERFLOW)
  Widget _categoryDropdown(SpentController controller) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: _inputDecoration(
        label: 'Category',
        child: SvgPicture.asset(
          'assets/images/category.svg',
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            AppColors.secondaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      value: controller.selectedCategory,
      items: controller.categories
          .map(
            (category) => DropdownMenuItem<String>(
              value: category,
              child: Text(category, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (value) {
        controller.selectedCategory = value;
        controller.update();
      },
    );
  }

  // 🔹 INPUT DECORATION
  InputDecoration _inputDecoration({
    required String label,
    IconData? icon,
    Widget? child,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.secondaryColor) : child,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.secondaryColor, width: 1.5),
      ),
    );
  }
}
