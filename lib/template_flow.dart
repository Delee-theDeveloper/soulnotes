import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TemplateBrowserPage extends StatelessWidget {
  const TemplateBrowserPage({super.key});

  static const Color _backgroundTop = Color(0xFFFBF3EA);
  static const Color _backgroundBottom = Color(0xFFF3E2D3);
  static const Color _primary = Color(0xFF7A1824);

  static const List<MemorialTemplate> _templates = [
    MemorialTemplate(
      id: 'classic_memory',
      name: 'Classic Memory',
      subtitle: 'Warm cream background with elegant tribute typography',
      initialHeading: 'In Loving Memory',
      initialName: 'Elizabeth Johnson',
      initialDates: 'May 12, 1946 - Sept. 5, 2022',
      initialMessage: 'Always in our hearts, forever loved and missed.',
      previewImagePath: 'assets/flowers.png',
      palette: TemplatePalette(
        name: 'Warm Cream',
        backgroundTop: Color(0xFFF8F0E2),
        backgroundBottom: Color(0xFFF1E3D0),
        headingColor: Color(0xFF7A1824),
        bodyColor: Color(0xFF26221F),
      ),
    ),
    MemorialTemplate(
      id: 'sunrise',
      name: 'Soft Sunrise',
      subtitle: 'Gentle tan tones with a peaceful feel',
      initialHeading: 'Forever Remembered',
      initialName: 'Avery Williams',
      initialDates: 'Jan. 18, 1951 - Aug. 2, 2021',
      initialMessage: 'Your kindness and laughter remain with us each day.',
      previewImagePath: 'assets/candle.png',
      palette: TemplatePalette(
        name: 'Soft Tan',
        backgroundTop: Color(0xFFF8EEE1),
        backgroundBottom: Color(0xFFEEDFCB),
        headingColor: Color(0xFF734231),
        bodyColor: Color(0xFF3A3029),
      ),
    ),
    MemorialTemplate(
      id: 'serene_sky',
      name: 'Serene Sky',
      subtitle: 'Light parchment palette for reflective tributes',
      initialHeading: 'In Loving Memory',
      initialName: 'Daniel Harper',
      initialDates: 'Feb. 2, 1949 - Nov. 14, 2023',
      initialMessage: 'Rest in peace. Your legacy lives on in every story.',
      previewImagePath: 'assets/sn_splash_cover.png',
      palette: TemplatePalette(
        name: 'Parchment',
        backgroundTop: Color(0xFFFAF1E4),
        backgroundBottom: Color(0xFFF1E3CF),
        headingColor: Color(0xFF6A3C2D),
        bodyColor: Color(0xFF3B3029),
      ),
    ),
  ];

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
          itemCount: _templates.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final MemorialTemplate template = _templates[index];
            return _TemplateCard(
              template: template,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TemplateEditorPage(template: template),
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
  const TemplateEditorPage({super.key, required this.template});

  final MemorialTemplate template;

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
  late TemplatePalette _selectedPalette;

  List<TemplatePalette> get _paletteOptions => <TemplatePalette>[
    widget.template.palette,
    const TemplatePalette(
      name: 'Light Tan',
      backgroundTop: Color(0xFFFAEFE1),
      backgroundBottom: Color(0xFFF1E2CD),
      headingColor: Color(0xFF744433),
      bodyColor: Color(0xFF3B302A),
    ),
    const TemplatePalette(
      name: 'Stone Beige',
      backgroundTop: Color(0xFFF4E8D9),
      backgroundBottom: Color(0xFFEAD9C6),
      headingColor: Color(0xFF5B332A),
      bodyColor: Color(0xFF302723),
    ),
    const TemplatePalette(
      name: 'Warm Linen',
      backgroundTop: Color(0xFFF9F1E7),
      backgroundBottom: Color(0xFFEEE0CF),
      headingColor: Color(0xFF6A3E2E),
      bodyColor: Color(0xFF352B24),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedPalette = widget.template.palette;
    _headingController = TextEditingController(
      text: widget.template.initialHeading,
    );
    _nameController = TextEditingController(text: widget.template.initialName);
    _datesController = TextEditingController(
      text: widget.template.initialDates,
    );
    _messageController = TextEditingController(
      text: widget.template.initialMessage,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFE4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${widget.template.name} Editor',
          style: const TextStyle(color: _primary, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _PreviewCard(
              palette: _selectedPalette,
              heading: _headingController.text,
              name: _nameController.text,
              dates: _datesController.text,
              message: _messageController.text,
              photoBytes: _photoBytes,
              placeholderImagePath: widget.template.previewImagePath,
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
                    'Choose Background',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _paletteOptions.map((TemplatePalette palette) {
                      final bool isSelected = palette == _selectedPalette;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPalette = palette;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                palette.backgroundTop,
                                palette.backgroundBottom,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? _primary : Colors.white,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            palette.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: palette.headingColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
                    hint: 'Elizabeth Johnson',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  _EditorField(
                    controller: _datesController,
                    label: 'Dates',
                    hint: 'May 12, 1946 - Sept. 5, 2022',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  _EditorField(
                    controller: _messageController,
                    label: 'Personal Message',
                    hint: 'Always in our hearts, forever loved and missed.',
                    maxLines: 3,
                    onChanged: (_) => setState(() {}),
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
              _MiniTemplatePreview(
                palette: template.palette,
                previewImagePath: template.previewImagePath,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniTemplatePreview extends StatelessWidget {
  const _MiniTemplatePreview({
    required this.palette,
    required this.previewImagePath,
  });

  final TemplatePalette palette;
  final String previewImagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 144,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.backgroundTop, palette.backgroundBottom],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.82),
            child: Text(
              'In Loving\nMemory',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.headingColor,
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 62,
                height: 72,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.88),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(previewImagePath, fit: BoxFit.cover),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            palette.headingColor.withValues(alpha: 0.12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.73),
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: palette.bodyColor.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.palette,
    required this.heading,
    required this.name,
    required this.dates,
    required this.message,
    required this.photoBytes,
    required this.placeholderImagePath,
  });

  final TemplatePalette palette;
  final String heading;
  final String name;
  final String dates;
  final String message;
  final Uint8List? photoBytes;
  final String placeholderImagePath;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [palette.backgroundTop, palette.backgroundBottom],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
            child: Column(
              children: [
                Text(
                  heading.trim().isEmpty ? 'In Loving Memory' : heading,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: palette.headingColor,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: photoBytes != null
                        ? Image.memory(
                            photoBytes!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                placeholderImagePath,
                                fit: BoxFit.cover,
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.14),
                                      palette.headingColor.withValues(
                                        alpha: 0.1,
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
                Text(
                  name.trim().isEmpty ? 'Full Name' : name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 38,
                    height: 1.02,
                    fontWeight: FontWeight.w600,
                    color: palette.headingColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  dates.trim().isEmpty ? 'Birth - Departure' : dates,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: palette.bodyColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message.trim().isEmpty ? 'Always in our hearts.' : message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.5,
                    height: 1.35,
                    color: palette.bodyColor,
                  ),
                ),
              ],
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

class MemorialTemplate {
  const MemorialTemplate({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.initialHeading,
    required this.initialName,
    required this.initialDates,
    required this.initialMessage,
    required this.previewImagePath,
    required this.palette,
  });

  final String id;
  final String name;
  final String subtitle;
  final String initialHeading;
  final String initialName;
  final String initialDates;
  final String initialMessage;
  final String previewImagePath;
  final TemplatePalette palette;
}

class TemplatePalette {
  const TemplatePalette({
    required this.name,
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.headingColor,
    required this.bodyColor,
  });

  final String name;
  final Color backgroundTop;
  final Color backgroundBottom;
  final Color headingColor;
  final Color bodyColor;
}
