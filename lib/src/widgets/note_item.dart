import 'package:flutter/material.dart';
import 'package:low_notes/src/models/note_model.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({super.key, required this.note});

  final NoteModel note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    final textColor = isDarkTheme ? Colors.white : Colors.black;

    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: theme.dividerColor.withAlpha(
                (0.5 * 255).toInt())), // Use withAlpha instead of withOpacity
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                  maxHeight: 200,
                ),
                child: Image.network(
                  note.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          if (note.title.isNotEmpty) ...[
            Text(
              note.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (note.note.toPlainText().trim().isNotEmpty) ...[
            const SizedBox(height: 4.0),
            Text(
              note.note.toPlainText().trim(),
              style: TextStyle(color: textColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
