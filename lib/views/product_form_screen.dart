import 'package:eCommerce/providers/product.dart';
import 'package:eCommerce/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _formData = Map<String, Object>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  //METHODS
  bool _isValidUrl(String url) {
    bool startsWithHttp = url.toLowerCase().startsWith('http://');
    bool startsWithHttps = url.toLowerCase().startsWith('https://');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithPng = url.toLowerCase().endsWith('.png');

    return (startsWithHttp || startsWithHttps) &&
        (endsWithJpeg || endsWithJpg || endsWithPng);
  }

  Future<void> _onSaved() async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) return;

    _formKey.currentState.save();

    final newProduct = Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
      price: _formData['price'],
    );
    setState(() {
      _isLoading = true;
    });

    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    try {
      print(_formData['id']);
      if (_formData['id'] == null) {
        await productProvider.addProduct(newProduct);
      } else {
        await productProvider.updateProduct(newProduct);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Erro!'),
                content: Text('Ocorrou um erro ao salvar o produto!'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));
      print(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateImg() {
    if (_isValidUrl(_imgUrlController.text)) {
      setState(() => {});
    }
  }
  // END METHODS

  @override
  void initState() {
    super.initState();
    _imgUrlFocusNode.addListener(_updateImg);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;

      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imgUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgUrlFocusNode.removeListener(_updateImg);
    _imgUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar produto'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _onSaved(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _formData['title'],
                      decoration: InputDecoration(
                        labelText: 'Título',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) => _formData['title'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = value.trim().length < 3;
                        if (isEmpty || isInvalid) {
                          return 'Informe um título com no mínimo 3 caracteres';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      decoration: InputDecoration(
                        labelText: 'Preço',
                      ),
                      focusNode: _priceFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value),
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        var newPrice = double.tryParse(value);
                        bool isInvalid = newPrice == null || newPrice <= 0;
                        if (isEmpty || isInvalid) {
                          return 'Digite um preço válido!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                      ),
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descFocusNode,
                      onSaved: (value) => _formData['description'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = value.trim().length < 10;
                        if (isEmpty || isInvalid) {
                          return 'Informe uma descrição com no mínimo 10 caracteres';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Imagem URL',
                            ),
                            keyboardType: TextInputType.url,
                            focusNode: _imgUrlFocusNode,
                            controller: _imgUrlController,
                            onSaved: (value) => _formData['imageUrl'] = value,
                            onFieldSubmitted: (_) => _onSaved(),
                            validator: (value) {
                              bool isEmpty = value.trim().isEmpty;
                              bool isInvalid = !_isValidUrl(value);
                              if (isEmpty || isInvalid) {
                                return 'Digite uma URL válida!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: _imgUrlController.text.isEmpty
                              ? Text(
                                  'Informe a URL',
                                  softWrap: true,
                                )
                              : Image.network(
                                  _imgUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
