import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'memories_store.dart';
import 'template_flow.dart';

class MyMemoriesPage extends StatelessWidget {
  const MyMemoriesPage({super.key});

  static const Color _backgroundTop = Color(0xFFFFFCF8);
  static const Color _backgroundBottom = Color(0xFFF8EFE5);
  static const Color _primary = Color(0xFF7A1824);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundTop,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Memories',
          style: TextStyle(color: _primary, fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_backgroundTop, _backgroundBottom],
          ),
        ),
        child: ValueListenableBuilder<List<SavedTribute>>(
          valueListenable: MemoriesStore.savedTributes,
          builder: (context, savedTributes, _) {
            if (savedTributes.isEmpty) {
              return const _EmptyMemoriesState();
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
              itemCount: savedTributes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final SavedTribute tribute = savedTributes[index];
                return _SavedTributeTile(tribute: tribute);
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyMemoriesState extends StatelessWidget {
  const _EmptyMemoriesState();

  static const Color _primary = Color(0xFF7A1824);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: const Color(0xFFF2E4D8),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _primary.withValues(alpha: 0.3)),
              ),
              child: const Icon(
                Icons.collections_bookmark_rounded,
                color: _primary,
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No saved tributes yet',
              style: TextStyle(
                color: _primary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Once you save a tribute from the editor, it will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.35,
                color: Color(0xFF7A6253),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedTributeTile extends StatelessWidget {
  const _SavedTributeTile({required this.tribute});

  final SavedTribute tribute;

  static const Color _primary = Color(0xFF7A1824);

  String _tributeText() {
    return [
      tribute.heading,
      tribute.name,
      tribute.dates,
      tribute.message,
    ].join('\n\n');
  }

  String _safeFileBase(String input) {
    final String cleaned = input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    if (cleaned.isEmpty) {
      return 'tribute';
    }
    return cleaned;
  }

  Future<void> _shareTribute(
    BuildContext context, {
    required _MemoriesAction action,
  }) async {
    final String shareText;
    final String subject = 'In Loving Memory: ${tribute.name}';
    switch (action) {
      case _MemoriesAction.share:
        shareText = _tributeText();
        break;
      case _MemoriesAction.shareSocial:
        shareText = '${_tributeText()}\n\n#SoulNotes #InLovingMemory';
        break;
      case _MemoriesAction.shareEmail:
        shareText = '${_tributeText()}\n\nShared from SoulNotes';
        break;
      case _MemoriesAction.shareMessages:
        shareText = '${tribute.heading}\n${tribute.name}\n${tribute.dates}';
        break;
      case _MemoriesAction.shareAirdrop:
        shareText = _tributeText();
        break;
      case _MemoriesAction.download:
      case _MemoriesAction.delete:
        return;
    }

    await Share.share(shareText, subject: subject);

    if (action == _MemoriesAction.shareAirdrop && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Use AirDrop or Nearby Share in the share sheet.'),
        ),
      );
    }
  }

  Future<void> _downloadTribute(BuildContext context) async {
    try {
      final Directory docsDir = await getApplicationDocumentsDirectory();
      final Directory memoriesDir = Directory(
        '${docsDir.path}/soulnotes_exports',
      );
      if (!await memoriesDir.exists()) {
        await memoriesDir.create(recursive: true);
      }
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = '${_safeFileBase(tribute.name)}_$timestamp.txt';
      final File exportFile = File('${memoriesDir.path}/$fileName');
      await exportFile.writeAsString(_tributeText());

      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded to ${exportFile.path}')),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to download this tribute.')),
      );
    }
  }

  Future<void> _deleteTribute(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Tribute?'),
          content: const Text('This tribute will be removed from My Memories.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    MemoriesStore.removeById(tribute.id);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${tribute.name} deleted')));
  }

  Future<void> _onActionSelected(
    BuildContext context,
    _MemoriesAction action,
  ) async {
    switch (action) {
      case _MemoriesAction.edit:
        await _editTribute(context);
        break;
      case _MemoriesAction.download:
        await _downloadTribute(context);
        break;
      case _MemoriesAction.share:
      case _MemoriesAction.shareSocial:
      case _MemoriesAction.shareEmail:
      case _MemoriesAction.shareMessages:
      case _MemoriesAction.shareAirdrop:
        await _shareTribute(context, action: action);
        break;
      case _MemoriesAction.delete:
        await _deleteTribute(context);
        break;
    }
  }

  Future<void> _editTribute(BuildContext context) async {
    final MemorialTemplate template = memorialTemplates.firstWhere(
      (item) => item.id == tribute.templateId,
      orElse: () => memorialTemplates.first,
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TemplateEditorPage(
          initialTemplate: template,
          existingTribute: tribute,
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF5C4235)),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _primary.withValues(alpha: 0.25), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MiniTributePreview(tribute: tribute),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        tribute.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                          color: _primary,
                        ),
                      ),
                    ),
                    PopupMenuButton<_MemoriesAction>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: _primary.withValues(alpha: 0.9),
                      ),
                      onSelected: (action) =>
                          _onActionSelected(context, action),
                      itemBuilder: (context) => [
                        PopupMenuItem<_MemoriesAction>(
                          value: _MemoriesAction.edit,
                          child: _menuItem(Icons.edit_rounded, 'Edit'),
                        ),
                        PopupMenuItem<_MemoriesAction>(
                          value: _MemoriesAction.download,
                          child: _menuItem(Icons.download_rounded, 'Download'),
                        ),
                        PopupMenuItem<_MemoriesAction>(
                          value: _MemoriesAction.share,
                          child: _menuItem(Icons.ios_share_rounded, 'Share'),
                        ),
                        PopupMenuItem<_MemoriesAction>(
                          value: _MemoriesAction.shareSocial,
                          child: _menuItem(
                            Icons.public_rounded,
                            'Share to Social Media',
                          ),
                        ),
                        PopupMenuItem<_MemoriesAction>(
                          value: _MemoriesAction.shareEmail,
                          child: _menuItem(
                            Icons.email_rounded,
                            'Share via Email',
                          ),
                        ),
                        PopupMenuItem<_MemoriesAction>(
                          value: _MemoriesAction.shareMessages,
                          child: _menuItem(
                            Icons.chat_bubble_rounded,
                            'Share via Messages',
                          ),
                        ),
                        PopupMenuItem<_MemoriesAction>(
                          value: _MemoriesAction.shareAirdrop,
                          child: _menuItem(
                            Icons.near_me_rounded,
                            'AirDrop / Nearby Share',
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<_MemoriesAction>(
                          value: _MemoriesAction.delete,
                          child: _menuItem(
                            Icons.delete_forever_rounded,
                            'Delete',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  tribute.heading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _primary.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tribute.dates,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.25,
                    color: Color(0xFF705B4E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tribute.message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                    color: Color(0xFF6F5A4D),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Saved ${_formatSavedDate(tribute.createdAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B7568),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _MemoriesAction {
  edit,
  download,
  share,
  shareSocial,
  shareEmail,
  shareMessages,
  shareAirdrop,
  delete,
}

class _MiniTributePreview extends StatelessWidget {
  const _MiniTributePreview({required this.tribute});

  final SavedTribute tribute;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 164,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(tribute.backgroundAssetPath, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFFF8F0).withValues(alpha: 0.54),
                    const Color(0xFFF2E6D8).withValues(alpha: 0.74),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    tribute.heading,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF6B1A28),
                      fontSize: 8.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: tribute.photoBytes != null
                          ? Image.memory(
                              tribute.photoBytes!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : const ColoredBox(
                              color: Color(0xFFE6D7C9),
                              child: Icon(
                                Icons.person_rounded,
                                color: Color(0xFF7A1824),
                                size: 32,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tribute.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF6B1A28),
                      fontSize: 11,
                      height: 1.05,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatSavedDate(DateTime dateTime) {
  const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final String month = months[dateTime.month - 1];
  return '$month ${dateTime.day}, ${dateTime.year}';
}
