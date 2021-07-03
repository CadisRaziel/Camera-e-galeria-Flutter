import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //quando importar o image_picker ja instancie ele aqui
  ImagePicker imagePicker = ImagePicker();

  //para usar o file importe o import 'dart:io';
  File? imagemSelecionada;

  pegarImagemGaleria() async {
    //sempre que pegarmos alguma foto de nosso celular ele vai ser async
    //aqui estamos pegando uma foto da geleria do celular
    final PickedFile? imagemTemporaria =
        await imagePicker.getImage(source: ImageSource.gallery);

    //conferindo se a imagem realmente veio
    if (imagemTemporaria != null) {

      //colocando a função que vai cortar a imagem
      File imagemCortada =  await cortarImagem(File(imagemTemporaria.path));

      setState(() {
        //Ja que ela vai ser exibida no app a gente precisa alterar o estado, por isso o setState
        //o File é que vai transformar a imagemTemporaria em um arquivo
        imagemSelecionada = File(imagemCortada.path);
      });
    }
  }

  pegarImagemCamera() async {
    //sempre que pegarmos alguma foto de nosso celular ele vai ser async
    //aqui estamos pegando uma foto da geleria do celular
    final PickedFile? imagemTemporaria =
        await imagePicker.getImage(source: ImageSource.camera);

    //conferindo se a imagem realmente veio
    if (imagemTemporaria != null) {

      //colocando a função que vai cortar a imagem
     File imagemCortada =  await cortarImagem(File(imagemTemporaria.path));

      setState(() {
        //Ja que ela vai ser exibida no app a gente precisa alterar o estado, por isso o setState
        //o File é que vai transformar a imagemTemporaria em um arquivo
        imagemSelecionada = File(imagemCortada.path);
      });
    }
  }

  //essa função de cortar imagem vai nos dar um atributo do celular muito especial
  //que é aquele aonde ele coloca imagem dentro de um quadrado para voce aumentar ou diminuir conforme quer cortar
  //o 'Edit photo' e la vai ter os 'CropAspectRatioPreset' conforme definimos ali
  cortarImagem(File imagemTemporaria) async {
    //toda imagem que tiver com essa função sera cortada conforme definimos
    //aqui nao precisamos conferir se o arquivo veio, pois ela ja esta sendo feita ali no 'pegarImagemCamera e pegarImagemGaleria'
    return await ImageCropper.cropImage(sourcePath: imagemTemporaria.path,

        //atributo que vai ser setado para ser cortado, para evitar que o usuario faça bobagem
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagem'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //vamos pesquisar se nossa imagemSelecionada é == null
          imagemSelecionada == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(36),
                  child: Image.file(imagemSelecionada!),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  pegarImagemGaleria();
                },
                icon: Icon(Icons.add_photo_alternate_outlined),
              ),
              IconButton(
                onPressed: () {
                  pegarImagemCamera();
                },
                icon: Icon(Icons.camera_alt_outlined),
              ),
            ],
          )
        ],
      ),
    );
  }
}

//Para colocar a permisão faça o seguinte
//Clique na pasta Android > app > src > main > AndroidManifest.xml e adicone: <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />

//Para retirar a action bar
// Clique na pasta Android > app > src > main > AndroidManifest.xml e va até </activity> e coloque:
//<activity
// <activity
//     android:name="com.yalantis.ucrop.UCropActivity"
//     android:screenOrientation="portrait"
//     android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
//Obs: esta na pagina do image_cropper do pub.dev

// CropAspectRatioPreset.ratio16x9 = formato de televisão
// CropAspectRatioPreset.ratio4x3 = formato vertical
// CropAspectRatioPreset.square = fica quadrado 1x1
