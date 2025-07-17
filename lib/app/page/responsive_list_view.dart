import 'package:flutter/material.dart';

class ResponsiveListView extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final List<String> primaryColumns;
  final List<String> secondaryColumns;
  final Function(dynamic) onItemTap;
  final Function(dynamic) onDelete;

  const ResponsiveListView({
    super.key,
    required this.items,
    required this.primaryColumns,
    required this.secondaryColumns,
    required this.onItemTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: Key(item['id'].toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            onDelete(item);
            return false;
          },
          child: ListTile(
            title: Text(primaryColumns.map((col) => item[col]?.toString() ?? '').join(' - ')),
            subtitle: secondaryColumns.isNotEmpty ? Text(secondaryColumns.map((col) => item[col]?.toString() ?? '').join(' | ')) : null,
            onTap: () => onItemTap(item),
          ),
        );
      },
    );
  }
}