
import 'package:flutter/material.dart';

class MobileRefreshList<T> extends StatelessWidget {
  final List<T> items; 
  final bool hasBaseData; 
  final bool isSearching;
  final String query;   
  final Future<void> Function() onRefresh;
  final Widget Function(BuildContext context, T item, int index, List<T> items) itemBuilder;

  // opsional
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final String emptyAllMessage;    
  final String emptySearchPrefix; 

  const MobileRefreshList({
    super.key,
    required this.items,
    required this.hasBaseData,
    required this.isSearching,
    required this.query,
    required this.onRefresh,
    required this.itemBuilder,
    this.controller,
    this.padding,
    this.emptyAllMessage = 'Belum ada data',
    this.emptySearchPrefix = 'Tidak ada hasil untuk',
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: Colors.white.withValues(alpha: 0.1),
      color: const Color(0xFF10B981),
      strokeWidth: 3,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (!hasBaseData) {
      return _EmptyScrollable(message: emptyAllMessage);
    }

    if (isSearching && items.isEmpty) {
      return _EmptyScrollable(message: '$emptySearchPrefix "$query"');
    }

    // 3) Ada data → tampilkan list
    return ListView.builder(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: padding ?? const EdgeInsets.only(bottom: 20),
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index], index, items),
    );
  }
}

class _EmptyScrollable extends StatelessWidget {
  final String message;
  const _EmptyScrollable({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        const SizedBox(height: 32),
        Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
