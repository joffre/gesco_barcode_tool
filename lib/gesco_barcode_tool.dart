import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ViewMode {
  grid,
  list,
}

class GWBarcodeTool extends HookWidget {
  const GWBarcodeTool({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final codes = useState<List<String>>(<String>[]);
    final selectedViewMode = useState<ViewMode>(ViewMode.grid);
    return Scaffold(
      appBar: AppBar(
        title: Text("BARCODE_TOOL"),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: codes.value.length > 4 ? codes.value.length + 1 : 5,
                    onChanged: (value) async {
                      if (value.isEmpty) {
                        codes.value = [];
                        return;
                      }
                      final values = value.split('\n');
                      codes.value = values.map((e) => e.trim().toUpperCase()).where((e) => e.isNotEmpty).toList();
                    },
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ToggleButtons(
                      isSelected: ViewMode.values.map((mode) => selectedViewMode.value == mode).toList(),
                      children: ViewMode.values.map((mode) {
                        switch (mode) {
                          case ViewMode.grid:
                            return Icon(Icons.grid_view_outlined);
                          case ViewMode.list:
                            return Icon(Icons.view_list_outlined);
                        }
                      }).toList(),
                      onPressed: (index) {
                        selectedViewMode.value = ViewMode.values[index];
                      },
                    ),
                    SizedBox(height: 12.0),
                    BarcodesShowcaseLayout(
                      viewMode: selectedViewMode.value,
                      children: codes.value
                          .map(
                            (code) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BarcodeSelector(code: code),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Generate and download',
        child: const Icon(Icons.cloud_download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BarcodesShowcaseLayout extends StatelessWidget {
  final List<Widget> children;
  final ViewMode viewMode;

  const BarcodesShowcaseLayout({Key? key, required this.children, required this.viewMode,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (viewMode) {
      case ViewMode.grid:
        return Wrap(
          runSpacing: 8.0,
          spacing: 8.0,
          children: children,
        );
      case ViewMode.list:
       return Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        );
    }

    return Container();
  }
}


class BarcodeSelector extends HookWidget {
  final String code;

  const BarcodeSelector({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final validTypes = [BarcodeType.CodeEAN13, BarcodeType.Codabar, BarcodeType.QrCode,].where((type) => Barcode.fromType(type).isValid(code)).toList();
    final selectedType = useState<BarcodeType>(validTypes.first);
    useEffect(() {
      selectedType.value = validTypes.first;
      return null;
    }, [validTypes]);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GWBarcode(
          code: code,
          type: selectedType.value,
        ),
        if (validTypes.isNotEmpty)
        DropdownButton<BarcodeType>(
          hint: Text('Type'),
          value: selectedType.value,
          items:
          validTypes.map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name),
                ),
              )
              .toList(),
          onChanged: (type) => selectedType.value = type ?? BarcodeType.Code39,
        ),
      ],
    );
  }
}

class GWBarcode extends StatelessWidget {
  final String code;
  final BarcodeType type;
  const GWBarcode({
    Key? key,
    required this.code,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a DataMatrix barcode
    final bc = Barcode.fromType(type);

    try {
      final typeSize = _barcodeSize(type);
      final svg = bc.toSvg(code, width: typeSize.width, height: typeSize.height,);
      return SvgPicture.string(svg);
    } catch (e) {
      return Container(child: Text(e.toString()),);
    }
  }
}

Size _barcodeSize(BarcodeType type) {
  switch (type) {
    case BarcodeType.CodeITF16:
      // TODO: Handle this case.
      break;
    case BarcodeType.CodeITF14:
      // TODO: Handle this case.
      break;
    case BarcodeType.CodeEAN13:
      return Size(400, 100);
    case BarcodeType.CodeEAN8:
      // TODO: Handle this case.
      break;
    case BarcodeType.CodeEAN5:
      // TODO: Handle this case.
      break;
    case BarcodeType.CodeEAN2:
      // TODO: Handle this case.
      break;
    case BarcodeType.CodeISBN:
      // TODO: Handle this case.
      break;
    case BarcodeType.Code39:
      // TODO: Handle this case.
      break;
    case BarcodeType.Code93:
      // TODO: Handle this case.
      break;
    case BarcodeType.CodeUPCA:
      // TODO: Handle this case.
      break;
    case BarcodeType.CodeUPCE:
      // TODO: Handle this case.
      break;
    case BarcodeType.Code128:
      // TODO: Handle this case.
      break;
    case BarcodeType.GS128:
      // TODO: Handle this case.
      break;
    case BarcodeType.Telepen:
      // TODO: Handle this case.
      break;
    case BarcodeType.QrCode:
      return Size(200, 200);
    case BarcodeType.Codabar:
      return Size(400, 100);
    case BarcodeType.PDF417:
      // TODO: Handle this case.
      break;
    case BarcodeType.DataMatrix:
      // TODO: Handle this case.
      break;
    case BarcodeType.Aztec:
      // TODO: Handle this case.
      break;
    case BarcodeType.Rm4scc:
      // TODO: Handle this case.
      break;
    case BarcodeType.Itf:
      // TODO: Handle this case.
      break;
  }
  return Size(200, 200);
}
