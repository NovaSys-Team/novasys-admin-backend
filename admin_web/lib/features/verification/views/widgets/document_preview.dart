import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../models/verification_request.dart';

/// Deliberately watermarked prototype pages, not fabricated identity documents.
class DocumentThumbnail extends StatelessWidget {
  const DocumentThumbnail({super.key, required this.document});
  final VerificationDocument document;
  @override
  Widget build(BuildContext context) => Material(
    color: AdminColors.background,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      key: ValueKey('preview-${document.type.name}'),
      borderRadius: BorderRadius.circular(8),
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => DocumentPreview(document: document),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 130,
              child: FittedBox(
                child: SizedBox(
                  width: 800,
                  height: 600,
                  child: _MockPage(document: document, page: 1),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Open ${document.format == DocumentFormat.pdf ? 'PDF' : 'image'} placeholder',
              style: const TextStyle(fontSize: 11, color: AdminColors.teal),
            ),
          ],
        ),
      ),
    ),
  );
}

class DocumentPreview extends StatefulWidget {
  const DocumentPreview({super.key, required this.document});
  final VerificationDocument document;
  @override
  State<DocumentPreview> createState() => _DocumentPreviewState();
}

class _DocumentPreviewState extends State<DocumentPreview> {
  final _transform = TransformationController();
  int _page = 1;
  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _zoom(double factor) {
    final zoom = (_transform.value.getMaxScaleOnAxis() * factor).clamp(.5, 4.0);
    _transform.value = Matrix4.diagonal3Values(zoom, zoom, 1);
  }

  @override
  Widget build(BuildContext context) => Dialog.fullscreen(
    child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  widget.document.type.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Text(
                  'DEMO PLACEHOLDER · No actual file attached',
                  style: TextStyle(fontSize: 11, color: AdminColors.teal),
                ),
                IconButton(
                  tooltip: 'Zoom in',
                  onPressed: () => _zoom(1.25),
                  icon: const Icon(Icons.zoom_in),
                ),
                IconButton(
                  tooltip: 'Zoom out',
                  onPressed: () => _zoom(.8),
                  icon: const Icon(Icons.zoom_out),
                ),
                TextButton(
                  onPressed: () => _transform.value = Matrix4.identity(),
                  child: const Text('Reset zoom'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close preview'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ColoredBox(
              color: AdminColors.background,
              child: InteractiveViewer(
                transformationController: _transform,
                minScale: .5,
                maxScale: 4,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: FittedBox(
                      child: SizedBox(
                        width: 800,
                        height: 600,
                        child: _MockPage(
                          document: widget.document,
                          page: _page,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.document.format == DocumentFormat.pdf)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TextButton(
                    onPressed: _page > 1
                        ? () => setState(() {
                            _page--;
                            _transform.value = Matrix4.identity();
                          })
                        : null,
                    child: const Text('Previous page'),
                  ),
                  Text(
                    'Page $_page of ${widget.document.pageCount} · PDF placeholder',
                  ),
                  TextButton(
                    onPressed: _page < widget.document.pageCount
                        ? () => setState(() {
                            _page++;
                            _transform.value = Matrix4.identity();
                          })
                        : null,
                    child: const Text('Next page'),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

class _MockPage extends StatelessWidget {
  const _MockPage({required this.document, required this.page});
  final VerificationDocument document;
  final int page;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AdminColors.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NOVASYS · DOCUMENT PREVIEW SAMPLE',
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 1,
            color: AdminColors.teal,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          document.type.label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Container(
              width: 90,
              height: 100,
              color: AdminColors.banner,
              child: Icon(
                document.format == DocumentFormat.pdf
                    ? Icons.picture_as_pdf_outlined
                    : Icons.image_outlined,
                size: 42,
                color: AdminColors.teal,
              ),
            ),
            const SizedBox(width: 24),
            const Expanded(
              child: Text(
                'PLACEHOLDER CONTENT\nNo personal information or credentials\nNo government seals or signatures',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.8,
                  color: AdminColors.muted,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        const Text(
          'SAMPLE — NOT A VALID DOCUMENT',
          style: TextStyle(
            fontSize: 22,
            color: AdminColors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${document.format.name.toUpperCase()} placeholder · Page $page · Uploaded ${verificationDate(document.uploadedAt)}',
          style: const TextStyle(fontSize: 12, color: AdminColors.muted),
        ),
      ],
    ),
  );
}
