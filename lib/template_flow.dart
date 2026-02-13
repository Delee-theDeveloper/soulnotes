import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'memories_store.dart';
import 'my_memories_page.dart';

class TemplateBrowserPage extends StatelessWidget {
  const TemplateBrowserPage({super.key});

  static const Color _backgroundTop = Color(0xFFFBF4EC);
  static const Color _backgroundBottom = Color(0xFFF3E6D8);
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
          'Browse Templates',
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
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          itemCount: memorialTemplates.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final MemorialTemplate template = memorialTemplates[index];
            return _TemplateCard(
              template: template,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        TemplateEditorPage(initialTemplate: template),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class TemplateEditorPage extends StatefulWidget {
  const TemplateEditorPage({
    super.key,
    required this.initialTemplate,
    this.existingTribute,
  });

  final MemorialTemplate initialTemplate;
  final SavedTribute? existingTribute;

  @override
  State<TemplateEditorPage> createState() => _TemplateEditorPageState();
}

class _TemplateEditorPageState extends State<TemplateEditorPage> {
  static const Color _primary = Color(0xFF7A1824);

  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _headingController;
  late final TextEditingController _nameController;
  late final TextEditingController _datesController;
  late final TextEditingController _messageController;

  Uint8List? _photoBytes;
  late MemorialTemplate _selectedTemplate;
  late String _selectedBackgroundAssetPath;

  @override
  void initState() {
    super.initState();
    _selectedTemplate = widget.initialTemplate;
    final SavedTribute? existingTribute = widget.existingTribute;
    _selectedBackgroundAssetPath =
        existingTribute?.backgroundAssetPath ??
        widget.initialTemplate.defaultBackgroundAssetPath;
    _headingController = TextEditingController(
      text: existingTribute?.heading ?? widget.initialTemplate.initialHeading,
    );
    _nameController = TextEditingController(
      text: existingTribute?.name ?? widget.initialTemplate.initialName,
    );
    _datesController = TextEditingController(
      text: existingTribute?.dates ?? widget.initialTemplate.initialDates,
    );
    _messageController = TextEditingController(
      text: existingTribute?.message ?? widget.initialTemplate.initialMessage,
    );
    _photoBytes = existingTribute?.photoBytes;
  }

  @override
  void dispose() {
    _headingController.dispose();
    _nameController.dispose();
    _datesController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final XFile? selected = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 2200,
    );
    if (selected == null) {
      return;
    }

    final Uint8List bytes = await selected.readAsBytes();
    setState(() {
      _photoBytes = bytes;
    });
  }

  String _resolvedText(String value, String fallback) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return fallback;
    }
    return trimmed;
  }

  void _saveToMyMemories() {
    final SavedTribute tribute = SavedTribute(
      id:
          widget.existingTribute?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      templateId: _selectedTemplate.id,
      backgroundAssetPath: _selectedBackgroundAssetPath,
      heading: _resolvedText(
        _headingController.text,
        _selectedTemplate.initialHeading,
      ),
      name: _resolvedText(_nameController.text, _selectedTemplate.initialName),
      dates: _resolvedText(
        _datesController.text,
        _selectedTemplate.initialDates,
      ),
      message: _resolvedText(
        _messageController.text,
        _selectedTemplate.initialMessage,
      ),
      photoBytes: _photoBytes == null ? null : Uint8List.fromList(_photoBytes!),
      createdAt: widget.existingTribute?.createdAt ?? DateTime.now(),
    );

    MemoriesStore.save(tribute);
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MyMemoriesPage()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFE4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${_selectedTemplate.name} Editor',
          style: const TextStyle(color: _primary, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _PreviewCard(
              template: _selectedTemplate,
              backgroundAssetPath: _selectedBackgroundAssetPath,
              heading: _headingController.text,
              name: _nameController.text,
              dates: _datesController.text,
              message: _messageController.text,
              photoBytes: _photoBytes,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose Template Format',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 165,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: memorialTemplates.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final MemorialTemplate template =
                            memorialTemplates[index];
                        return _TemplateChoice(
                          template: template,
                          selected: template.id == _selectedTemplate.id,
                          onTap: () {
                            setState(() {
                              _selectedTemplate = template;
                              _selectedBackgroundAssetPath =
                                  template.defaultBackgroundAssetPath;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: tributeBackgroundAssets.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final String assetPath = tributeBackgroundAssets[index];
                        return _BackgroundChoice(
                          assetPath: assetPath,
                          selected: assetPath == _selectedBackgroundAssetPath,
                          onTap: () {
                            setState(() {
                              _selectedBackgroundAssetPath = assetPath;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _pickPhoto,
                      icon: const Icon(Icons.add_a_photo_rounded),
                      label: Text(
                        _photoBytes == null
                            ? 'Upload Loved One\'s Photo'
                            : 'Replace Photo',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _EditorField(
                    controller: _headingController,
                    label: 'Heading',
                    hint: 'In Loving Memory',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  _EditorField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Margaret Williams',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  _EditorField(
                    controller: _datesController,
                    label: 'Dates',
                    hint: 'March 8, 1952 - July 21, 2023',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  _EditorField(
                    controller: _messageController,
                    label: 'Personal Message',
                    hint: 'Forever remembered. Forever cherished.',
                    maxLines: 3,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveToMyMemories,
                      icon: const Icon(Icons.bookmark_added_rounded),
                      label: Text(
                        widget.existingTribute == null
                            ? 'Save to My Memories'
                            : 'Update My Memory',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
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

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, required this.onTap});

  final MemorialTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE9DCCF)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7A1824),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      template.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7B6458),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6E9DF),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text(
                        'Customize',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF7A1824),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  template.templateAssetPath,
                  width: 88,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplateChoice extends StatelessWidget {
  const _TemplateChoice({
    required this.template,
    required this.selected,
    required this.onTap,
  });

  final MemorialTemplate template;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 98,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? template.headingColor : const Color(0xFFE2D3C5),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  template.templateAssetPath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              template.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: selected
                    ? template.headingColor
                    : const Color(0xFF6D5245),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.template,
    required this.backgroundAssetPath,
    required this.heading,
    required this.name,
    required this.dates,
    required this.message,
    required this.photoBytes,
  });

  final MemorialTemplate template;
  final String backgroundAssetPath;
  final String heading;
  final String name;
  final String dates;
  final String message;
  final Uint8List? photoBytes;

  TextStyle _headingStyle() {
    switch (template.style) {
      case TributeLayoutStyle.classicMaroon:
        return TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w600,
          color: template.headingColor,
        );
      case TributeLayoutStyle.modernGray:
        return TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w500,
          color: template.headingColor,
        );
      case TributeLayoutStyle.roseElegance:
        return TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w600,
          color: template.headingColor,
        );
    }
  }

  TextStyle _nameStyle() {
    switch (template.style) {
      case TributeLayoutStyle.modernGray:
        return TextStyle(
          fontSize: 49,
          height: 1.0,
          fontWeight: FontWeight.w600,
          color: template.headingColor,
        );
      case TributeLayoutStyle.classicMaroon:
      case TributeLayoutStyle.roseElegance:
        return TextStyle(
          fontSize: 50,
          height: 0.98,
          fontWeight: FontWeight.w600,
          color: template.headingColor,
        );
    }
  }

  Widget _separator() {
    switch (template.style) {
      case TributeLayoutStyle.modernGray:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 1,
          color: template.accentColor.withValues(alpha: 0.8),
        );
      case TributeLayoutStyle.classicMaroon:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: template.accentColor.withValues(alpha: 0.7),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.auto_awesome,
                  size: 14,
                  color: template.accentColor,
                ),
              ),
              Expanded(
                child: Divider(
                  color: template.accentColor.withValues(alpha: 0.7),
                  thickness: 1,
                ),
              ),
            ],
          ),
        );
      case TributeLayoutStyle.roseElegance:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: template.accentColor.withValues(alpha: 0.72),
                  thickness: 1.2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.local_florist_rounded,
                  size: 16,
                  color: template.accentColor,
                ),
              ),
              Expanded(
                child: Divider(
                  color: template.accentColor.withValues(alpha: 0.72),
                  thickness: 1.2,
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String headingText = heading.trim().isEmpty
        ? template.initialHeading
        : heading.trim();
    final String nameText = name.trim().isEmpty
        ? template.initialName
        : name.trim();
    final String datesText = dates.trim().isEmpty
        ? template.initialDates
        : dates.trim();
    final String messageText = message.trim().isEmpty
        ? template.initialMessage
        : message.trim();

    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(backgroundAssetPath),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: template.accentColor.withValues(alpha: 0.36),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  template.backgroundTop.withValues(alpha: 0.55),
                  template.backgroundBottom.withValues(alpha: 0.68),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
              child: Column(
                children: [
                  Text(
                    headingText,
                    textAlign: TextAlign.center,
                    style: _headingStyle(),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white.withValues(alpha: 0.36),
                      ),
                      child: photoBytes != null
                          ? Image.memory(
                              photoBytes!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Image.asset(
                              template.placeholderPortraitPath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    nameText,
                    textAlign: TextAlign.center,
                    style: _nameStyle(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    datesText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                      color: template.bodyColor,
                    ),
                  ),
                  _separator(),
                  Text(
                    template.style == TributeLayoutStyle.roseElegance
                        ? '“$messageText”'
                        : messageText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.5,
                      height: 1.35,
                      color: template.bodyColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditorField extends StatelessWidget {
  const _EditorField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFFCF6EF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5D5C8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5D5C8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7A1824), width: 1.4),
        ),
      ),
    );
  }
}

class _BackgroundChoice extends StatelessWidget {
  const _BackgroundChoice({
    required this.assetPath,
    required this.selected,
    required this.onTap,
  });

  final String assetPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF7A1824) : const Color(0xFFE2D3C5),
            width: selected ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Image.asset(assetPath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

enum TributeLayoutStyle { classicMaroon, modernGray, roseElegance }

class MemorialTemplate {
  const MemorialTemplate({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.templateAssetPath,
    required this.placeholderPortraitPath,
    required this.style,
    required this.initialHeading,
    required this.initialName,
    required this.initialDates,
    required this.initialMessage,
    required this.defaultBackgroundAssetPath,
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.headingColor,
    required this.bodyColor,
    required this.accentColor,
  });

  final String id;
  final String name;
  final String subtitle;
  final String templateAssetPath;
  final String placeholderPortraitPath;
  final TributeLayoutStyle style;
  final String initialHeading;
  final String initialName;
  final String initialDates;
  final String initialMessage;
  final String defaultBackgroundAssetPath;
  final Color backgroundTop;
  final Color backgroundBottom;
  final Color headingColor;
  final Color bodyColor;
  final Color accentColor;
}

const List<String> tributeBackgroundAssets = [
  'assets/background templates/background01.png',
  'assets/background templates/background02.png',
  'assets/background templates/background03.png',
  'assets/background templates/background04.png',
  'assets/background templates/background05.png',
  'assets/background templates/background06.png',
  'assets/background templates/background07.png',
  'assets/background templates/background08.png',
  'assets/background templates/background09.png',
];

const List<MemorialTemplate> memorialTemplates = [
  MemorialTemplate(
    id: 'template_1',
    name: 'Template 1',
    subtitle: 'Classic maroon remembrance format',
    templateAssetPath: 'assets/templates/template 1.png',
    placeholderPortraitPath: 'assets/images/wel1.png',
    style: TributeLayoutStyle.classicMaroon,
    initialHeading: 'In Loving Memory',
    initialName: 'Margaret Williams',
    initialDates: 'March 8, 1952 - July 21, 2023',
    initialMessage: 'Forever remembered. Forever cherished.',
    defaultBackgroundAssetPath: 'assets/background templates/background01.png',
    backgroundTop: Color(0xFFF7EFE3),
    backgroundBottom: Color(0xFFEEE1D0),
    headingColor: Color(0xFF5A1D2A),
    bodyColor: Color(0xFF3E302A),
    accentColor: Color(0xFF8B4752),
  ),
  MemorialTemplate(
    id: 'template_2',
    name: 'Template 2',
    subtitle: 'Clean modern remembrance format',
    templateAssetPath: 'assets/templates/template 2.png',
    placeholderPortraitPath: 'assets/images/web2.jpg',
    style: TributeLayoutStyle.modernGray,
    initialHeading: 'Remembering',
    initialName: 'James Carter',
    initialDates: 'November 3, 1948 - January 14, 2024',
    initialMessage: 'Your light continues to shine through us.',
    defaultBackgroundAssetPath: 'assets/background templates/background04.png',
    backgroundTop: Color(0xFFF7F7F7),
    backgroundBottom: Color(0xFFEFEFEF),
    headingColor: Color(0xFF2E3135),
    bodyColor: Color(0xFF3D4044),
    accentColor: Color(0xFFB8B8B8),
  ),
  MemorialTemplate(
    id: 'template_3',
    name: 'Template 3',
    subtitle: 'Elegant rose remembrance format',
    templateAssetPath: 'assets/templates/template 3.png',
    placeholderPortraitPath: 'assets/images/wel3.jpg',
    style: TributeLayoutStyle.roseElegance,
    initialHeading: 'In Loving Memory',
    initialName: 'Patricia Robinson',
    initialDates: 'April 2, 1960 - September 30, 2021',
    initialMessage: 'Those we love never truly leave us.',
    defaultBackgroundAssetPath: 'assets/background templates/background07.png',
    backgroundTop: Color(0xFFF8F0E5),
    backgroundBottom: Color(0xFFEFE1D3),
    headingColor: Color(0xFF5B1D2A),
    bodyColor: Color(0xFF4A2E2E),
    accentColor: Color(0xFF8A3B49),
  ),
];
