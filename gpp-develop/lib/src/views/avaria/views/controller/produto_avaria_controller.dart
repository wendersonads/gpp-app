//import 'dart:html';

import 'package:get/get.dart';
import 'package:gpp/src/models/avaria/imagem_avaria_model.dart';
import 'package:video_player/video_player.dart';
import 'package:gpp/src/models/avaria/avaria_model.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gpp/src/models/avaria/video_avaria_model.dart';
import 'package:gpp/src/repositories/avaria_repository/avaria_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:gpp/src/enums/categoria_imagens_avaria_enum.dart';

class ProdutoAvariaController extends GetxController {
  late CategoriaImagensAvariaEnum? checkBoxCategoriaImagem = null;

  RxBool selecionandoImagens = false.obs;
  RxDouble grauAmassado = 0.0.obs;
  RxDouble grauArranhado = 0.0.obs;
  RxDouble grauQuebrado = 0.0.obs;
  RxDouble grauManchado = 0.0.obs;
  String labelGrauAvaria = '';
  late RxBool carregandoDados = false.obs;

  //Variaveis de controle do video
  late Rxn<VideoPlayerController> controllerVideoPlayer = Rxn();
  late Rxn<Future<void>> initializeVideoPlayerFuture = Rxn();
  RxString UrlVideo = ''.obs;
  RxBool isPlayVideo = false.obs;

  late TextEditingController descricaoDefeito = TextEditingController();
  late TextEditingController idProdutoSKU = TextEditingController();
  late TextEditingController idCor = TextEditingController();
  late TextEditingController ldOrigem = TextEditingController();
  late GlobalKey<FormState> formKey;
  int? idProduto = 1;

  late Rx<AvariaModel> criacaoAvaria;
  late Rx<AvariaModel> ProdutoAvaria;

  late AvariaRepository produtoAvariaRpository;

  ProdutoAvariaController() {
    criacaoAvaria = AvariaModel(
      idFilial: getFilial().id_filial,
      dataCria: DateTime.now(),
      videos: [],
      imagens: [],
      descricaoAvaria: descricaoDefeito.text,
      reSolicitador: getUsuario().uid,
    ).obs;

    ProdutoAvaria = AvariaModel(
      idFilial: getFilial().id_filial,
      dataCria: DateTime.now(),
      videos: [],
      imagens: [],
      descricaoAvaria: descricaoDefeito.text,
    ).obs;

    descricaoDefeito = TextEditingController();
    idProdutoSKU = TextEditingController();
    produtoAvariaRpository = AvariaRepository();
    formKey = GlobalKey<FormState>();
  }

  //Função que incrementa valor no slider
  void GrauAmassado(value) {
    grauAmassado.value = value;
  }

  void GrauArranhado(value) {
    grauArranhado.value = value;
  }

  void GrauQuebrado(value) {
    grauQuebrado.value = value;
  }

  void GrauManchado(value) {
    grauManchado.value = value;
  }

  tamanhoLista(CategoriaImagensAvariaEnum? checkBoxCategoriaImagem) {
    int tamanho = 0;
    for (ImagemAvariaModel i in criacaoAvaria.value.imagens!) {
      if (i.categoria == checkBoxCategoriaImagem!.value.toString()) {
        tamanho++;
      }
    }
    return tamanho;
  }

  /// Função reponsável por lidar com a seleção das imagens da solicitação
  /// da OS.
  Future<void> escolherImagens({ImageSource? origem}) async {
    try {
      final ImagePicker picker = ImagePicker();
      List<XFile> novasImagens = [];
      selecionandoImagens.value = true;
      if (!kIsWeb) {
        fecharDialog();
      }

      // Imagem da câmera
      if (origem == ImageSource.camera) {
        final XFile? imagemSelecionada = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 90,
        );

        if (imagemSelecionada != null) {
          novasImagens.add(imagemSelecionada);
        }
      } else {
        // Imagem(ns) da galeria
        List<XFile>? imagensSelecionadas = await picker.pickMultiImage(
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 90,
        );

        if (imagensSelecionadas != null && imagensSelecionadas.isNotEmpty) {
          // Verifica se existem algum arquivo que não seja uma imagem
          List<String> formatosArquivos = imagensSelecionadas
              .map((imagem) => imagem.name.split('.').last.toLowerCase())
              .toList();
          bool existeFormatoInvalido = formatosArquivos.any(
            (formato) => !['jpg'].contains(formato),
          );

          if (existeFormatoInvalido) {
            Notificacao.snackBar(
              'Selecione apenas imagens do formato jpg!',
              tipoNotificacao: TipoNotificacaoEnum.error,
            );
            selecionandoImagens.value = false;
            return;
          }

          // Verifica a quantidade de imagens selecionadas
          // if (imagensSelecionadas.length > 5) {
          //   Notificacao.snackBar(
          //     'Selecione, no máximo, 5 imagens!',
          //     tipoNotificacao: TipoNotificacaoEnum.error,
          //   );

          //   return;
          // }

          // Verifica a quantidade de imagens selecionadas por categoria
          if (imagensSelecionadas.length > 5 &&
              checkBoxCategoriaImagem?.value == 1) {
            Notificacao.snackBar(
              'Selecione no máximo 5 imagens!',
              tipoNotificacao: TipoNotificacaoEnum.error,
            );
            return;
          } else if (imagensSelecionadas.length > 5 &&
              checkBoxCategoriaImagem?.value == 2) {
            Notificacao.snackBar(
              'Selecione, no máximo, 5 imagens!',
              tipoNotificacao: TipoNotificacaoEnum.error,
            );

            return;
          } else if (imagensSelecionadas.length > 5 &&
              checkBoxCategoriaImagem?.value == 3) {
            Notificacao.snackBar(
              'Selecione, no máximo, 5 imagens!',
              tipoNotificacao: TipoNotificacaoEnum.error,
            );

            return;
          } else if (imagensSelecionadas.length > 5 &&
              checkBoxCategoriaImagem?.value == 4) {
            Notificacao.snackBar(
              'Selecione, no máximo, 5 imagens!',
              tipoNotificacao: TipoNotificacaoEnum.error,
            );

            return;
          }

          novasImagens.addAll(imagensSelecionadas);
        }
      }

      List<ImagemAvariaModel> novasImagensOs = await Future.wait(
        novasImagens.map((imagem) async {
          if (kIsWeb) {
            return ImagemAvariaModel(
              nome: imagem.name,
              base64: base64Encode(await imagem.readAsBytes()),
              url: imagem.path,
              categoria: checkBoxCategoriaImagem?.value.toString(),
            );
          }

          // Caso seja no app mobile, é necessário utilizar essa biblioteca
          // pois, por algum motivo, a imagem vem com a rotação errada
          return ImagemAvariaModel(
              nome: imagem.name,
              base64: base64Encode(
                await FlutterImageCompress.compressWithFile(
                      imagem.path,
                      rotate: 0,
                      quality: 90,
                      keepExif: false,
                      autoCorrectionAngle: true,
                      format: CompressFormat.jpeg,
                    ) ??
                    [],
              ),
              url: imagem.path,
              categoria: checkBoxCategoriaImagem?.value.toString());
        }).toList(),
      );

      // Caso o usuário ainda não tenha selecionado nenhuma imagem, adiciona todas as imagens selecionadas
      if (criacaoAvaria.value.imagens!.isEmpty) {
        criacaoAvaria.update((value) {
          value!.imagens = novasImagensOs;
          selecionandoImagens.value = false;
        });
      } else {
        // Caso contrário, é necessário verificar a quantidade de imagens já selecionadas
        int tamanho = 0;
        for (ImagemAvariaModel i in criacaoAvaria.value.imagens!) {
          if (i.categoria == checkBoxCategoriaImagem!.value.toString()) {
            tamanho++;
          }
        }
        if (tamanho + novasImagens.length > 5) {
          Notificacao.snackBar(
            'Selecione, no máximo, 5 imagens por categoria!',
            tipoNotificacao: TipoNotificacaoEnum.error,
          );

          return;
        }

        criacaoAvaria.update((value) {
          value!.imagens!.addAll(novasImagensOs);
          selecionandoImagens.value = false;
        });
      }
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
    }
  }

  //Função responsável por remover a imagem selecionada
  void removerImagemSelecionada(int index) {
    criacaoAvaria.update((value) {
      value!.imagens!.removeAt(index);
    });
  }

  void removerVideoSelecionado(int index) {
    criacaoAvaria.update((value) {
      value!.videos!.removeAt(index);
    });
  }

  /// Função de utilidade, responsável por fechar o modal e remover qualquer
  /// foco existente na tela.
  void fecharDialog() {
    Get.back();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  //Função responsavel por atualizar o estado do checkbox
  checkBoxImagem(CategoriaImagensAvariaEnum? value) {
    checkBoxCategoriaImagem = value;
    update();
  }

  //Verifica a quantidade máxima de imagens selecionada
  verificalimiteImagens(CategoriaImagensAvariaEnum? checkBoxCategoriaImagem) {
    int imagensSelecionadas = 0;
    for (ImagemAvariaModel i in criacaoAvaria.value.imagens!) {
      if (i.categoria == checkBoxCategoriaImagem!.value.toString()) {
        imagensSelecionadas++;
      }
    }
    if (imagensSelecionadas < 5) {
      return true;
    } else {
      return Notificacao.snackBar(
        'Selecione, no máximo, 5 Imagens por categoria!',
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
    }
  }

  tamanhoMinimo() {
    final List<ImagemAvariaModel> amassado = criacaoAvaria.value.imagens!
        .where((imagem) => imagem.categoria.toString() == '1')
        .toList();

    final List<ImagemAvariaModel> arranhado = criacaoAvaria.value.imagens!
        .where((imagem) => imagem.categoria.toString() == '2')
        .toList();

    final List<ImagemAvariaModel> quebrado = criacaoAvaria.value.imagens!
        .where((imagem) => imagem.categoria.toString() == '3')
        .toList();

    final List<ImagemAvariaModel> manchado = criacaoAvaria.value.imagens!
        .where((imagem) => imagem.categoria.toString() == '4')
        .toList();

    if (grauAmassado.value > 0.0) {
      if (amassado.length < 1) {
        Notificacao.snackBar(
          'Selecione no mínimo 1 imagem para categoria Amassado',
          tipoNotificacao: TipoNotificacaoEnum.error,
        );
        return true;
      }
    } else {
      return false;
    }
    if (grauArranhado.value > 0.0) {
      if (arranhado.length < 1) {
        Notificacao.snackBar(
          'Selecione no mínimo 1 imagem para categoria Arranhado',
          tipoNotificacao: TipoNotificacaoEnum.error,
        );
        return true;
      }
    } else {
      return false;
    }

    if (grauQuebrado.value > 0.0) {
      if (quebrado.length < 1) {
        Notificacao.snackBar(
          'Selecione no mínimo 1 imagem para categoria Quebrado',
          tipoNotificacao: TipoNotificacaoEnum.error,
        );
        return true;
      }
    } else {
      return false;
    }

    if (grauManchado.value > 0.0) {
      if (manchado.length < 1) {
        Notificacao.snackBar(
          'Selecione no mínimo 1 imagem para categoria Manchado',
          tipoNotificacao: TipoNotificacaoEnum.error,
        );
        return true;
      }
    } else {
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    controllerVideoPlayer.value = VideoPlayerController.network(
      '${UrlVideo.value}',
    );
  }

  @override
  void dispose() {
    super.dispose();
    controllerVideoPlayer.value!.dispose();
  }

//Função responsavel por anexar o video
  Future<void> escolherVideos({ImageSource? origem}) async {
    try {
      final ImagePicker picker = ImagePicker();
      List<XFile> novosVideos = [];

      // Video da câmera
      if (origem == ImageSource.camera) {
        final XFile? videoSelecionado = await picker.pickVideo(
          source: ImageSource.camera,
          maxDuration: const Duration(seconds: 20),
        );

        if (videoSelecionado != null) {
          novosVideos.add(videoSelecionado);
        }
      } else {
        // Video(s) da galeria
        final XFile? videoSelecionado = await picker.pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 20),
        );

        if (videoSelecionado != null) {
          // Verifica o tamanho do arquivo
          int tamanhoArquivoEmBytes = await videoSelecionado.length();
          double tamanhoArquivoEmMB = tamanhoArquivoEmBytes / (1024 * 1024);

          if (tamanhoArquivoEmMB > 8) {
            Notificacao.snackBar(
              'O tamanho do vídeo deve ser menor que 8 MB!',
              tipoNotificacao: TipoNotificacaoEnum.error,
            );

            return;
          }
          // Verifica se existem algum arquivo que não seja um video
          String formatoArquivo =
              videoSelecionado.name.split('.').last.toLowerCase();
          bool formatoInvalido =
              !['mp4', 'mov', 'mkv'].contains(formatoArquivo);

          if (formatoInvalido) {
            Notificacao.snackBar(
              'Selecione apenas videos!',
              tipoNotificacao: TipoNotificacaoEnum.error,
            );

            return;
          }
          novosVideos.add(videoSelecionado);
        } else {
          Notificacao.snackBar(
            'Selecione, no máximo, 1 video!',
            tipoNotificacao: TipoNotificacaoEnum.error,
          );
          return;
        }
      }

      List<VideoAvariaModel> novosVideosAvaria = await Future.wait(
        novosVideos.map((video) async {
          if (kIsWeb) {
            return VideoAvariaModel(
              nome: video.name,
              base64: base64Encode(await video.readAsBytes()),
              url: video.path,
            );
          }

          // Caso seja no app mobile, é necessário utilizar essa biblioteca
          // pois, por algum motivo, o video vem com a rotação errada
          return VideoAvariaModel(
            nome: video.name,
            base64: base64Encode(await video.readAsBytes()),
            url: video.path,
          );
        }).toList(),
      );

      // Caso o usuário ainda não tenha selecionado nenhum video, adiciona todos os videos selecionados
      if (criacaoAvaria.value.videos!.isEmpty) {
        criacaoAvaria.update((value) {
          value!.videos = novosVideosAvaria;
        });
        UrlVideo.value = criacaoAvaria.value.videos!.first.url!.toString();
        controllerVideoPlayer.value =
            VideoPlayerController.network('${UrlVideo.value.toString()}');
        initializeVideoPlayerFuture.value =
            controllerVideoPlayer.value!.initialize();
        controllerVideoPlayer.value!.setLooping(true);
      } else {
        // Caso contrário, é necessário verificar a quantidade de videos já selecionados
        if (criacaoAvaria.value.videos!.length + novosVideos.length > 1) {
          Notificacao.snackBar(
            'Selecione, no máximo, 1 video!',
            tipoNotificacao: TipoNotificacaoEnum.error,
          );

          return;
        }

        criacaoAvaria.update((value) {
          value!.videos!.addAll(novosVideosAvaria);
        });
      }
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
    }
  }

//Funcao responsavel por remover video.
  void revomerVideo(index) {
    criacaoAvaria.update((value) {
      value!.videos!.removeAt(index);
    });
    //reinicia o estado do botão play/pause
    isPlayVideo = false.obs;
  }

//Função valida formulário
  bool validaFormulario(idProdutoSku) {
    if (idProdutoSku == null || idProdutoSku.isEmpty) {
      Notificacao.snackBar('É necessário anexar informar o ID Produto/SKU',
          tipoNotificacao: TipoNotificacaoEnum.error);
      return true;
    } else {
      return false;
    }
  }

//Função de validação dos dados de cadastro do Produto Avariado
  bool validaCriacaoProdutoAvaria() {
    if (criacaoAvaria.value.idProduto == null) {
      Notificacao.snackBar('É necessário informar o ID Produto/SKU',
          tipoNotificacao: TipoNotificacaoEnum.error);
      return false;
    } else if (grauAmassado.value.toInt() == 0 &&
        grauArranhado.value.toInt() == 0 &&
        grauManchado.value.toInt() == 0 &&
        grauQuebrado.value.toInt() == 0) {
      Notificacao.snackBar('Informe o grau de Avaria do produto',
          tipoNotificacao: TipoNotificacaoEnum.error);

      return false;
    } else if (ldOrigem.text.isEmpty) {
      Notificacao.snackBar('É necessário informar o LD Origem',
          tipoNotificacao: TipoNotificacaoEnum.error);
      return false;
    }

    // Descomentar quando implementar o anexo video
    // else if (criacaoAvaria.value.videos!.length == 0 ||
    //     criacaoAvaria.value.videos!.isEmpty) {
    //   Notificacao.snackBar('É necessário anexar ao menos 1 vídeo',
    //       tipoNotificacao: TipoNotificacaoEnum.error);

    //   return false;
    // }

    else {
      String SidProduto = idProdutoSKU.text.toString();
      print('Conversão:  ${SidProduto}');
      print('criacaoAvaria:  ${criacaoAvaria.value.idProduto.toString()}');

      return true;
    }
  }

  //Funcao responsavel por criar capturar e enviar os dados do produto Avariado
  criarProdutoAvariado() {
    ProdutoAvaria.value = AvariaModel(
        idFilial: criacaoAvaria.value.idFilial, //criacaoAvaria.value.idFilial,
        idProduto: criacaoAvaria.value.idProduto,
        ldDestino: 9, //Avariado em loja
        ldOrigem: criacaoAvaria.value.ldOrigem,
        tipoAmassado: grauAmassado.value.toInt(),
        tipoArranhado: grauArranhado.value.toInt(),
        tipoManchado: grauManchado.value.toInt(),
        tipoQuebrado: grauQuebrado.value.toInt(),
        descricaoAvaria: descricaoDefeito.text,
        videos: criacaoAvaria.value.videos,
        imagens: criacaoAvaria.value.imagens,
        cor: 0,
        reSolicitador: criacaoAvaria.value.reSolicitador);
  }

//Função responsavel por enviar o dados do produto para repository
  Future<bool> salvarProdutoAvariado() async {
    try {
      carregandoDados.value = true;

      return await produtoAvariaRpository
          .criarProdutoAvaria(ProdutoAvaria.value);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
      return false;
    } finally {
      carregandoDados.value = false;
    }
  }
}
