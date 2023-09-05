import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:gpp/src/enums/categoria_de_imagens_enum.dart';
import 'package:gpp/src/models/video_os_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:gpp/src/enums/solicitacao_os_categoria_troca_enum.dart';
import 'package:gpp/src/enums/solicitacao_os_complemento_enum.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/solicitacao_os/checklist_os_model.dart';
import 'package:gpp/src/models/solicitacao_os/defeito_os_model.dart';
import 'package:gpp/src/models/solicitacao_os/digitalizacao_os_model.dart';
import 'package:gpp/src/models/solicitacao_os/imagem_os_model.dart';
import 'package:gpp/src/models/solicitacao_os/item_solicitacao_os_model.dart';
import 'package:gpp/src/models/solicitacao_os/produto_os_model.dart';
import 'package:gpp/src/models/solicitacao_os/solicitacao_os_model.dart';
import 'package:gpp/src/repositories/solicitacao_os_repositories/checklist_os_repository.dart';
import 'package:gpp/src/repositories/solicitacao_os_repositories/defeito_os_repository.dart';
import 'package:gpp/src/repositories/solicitacao_os_repositories/produto_os_repository.dart';
import 'package:gpp/src/repositories/solicitacao_os_repositories/solicitacao_os_repository.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:video_player/video_player.dart';

class SolicitacaoOSCriacaoController extends GetxController {
  // Estados referentes ao formulário principal da tela
  late GlobalKey<FormState> formKey;
  late Rx<SolicitacaoOSModel> solicitacao;
  late TextEditingController filialRetransfTextController;
  RxBool carregandoCriacao = false.obs;
  RxBool carregandoDefeitosChecklists = false.obs;
  RxBool selecionandoImagens = false.obs;
  late List<DefeitoOSModel> defeitos;
  late List<ChecklistOSModel> checklists;
  late SolicitacaoOSRepository solicitacaoOSRepository;
  late DefeitoOSRepository defeitoOSRepository;
  late ChecklistOSRepository checklistOSRepository;
  late CategoriaImagensEnum? checkBoxCategoriaImagem;

  // Estados referentes ao formulário de filtragem dos produtos da tela
  late GlobalKey<FormState> formFiltragemProdutosKey;
  String? buscarProdutoFiltro;
  int? ldProdutoFiltro;
  RxBool carregandoProdutos = false.obs;
  late List<ProdutoOSModel> produtos;
  RxString codigoProdutoSelecionado = ''.obs;
  late ProdutoOSRepository produtoOSRepository;
  late PaginaModel paginaProdutos;

  // Estados gerais
  late MaskFormatter maskFormatter;
  late NumberFormat formatter;
  late Rxn<VideoPlayerController> controllerVideo = Rxn();
  late Rxn<Future<void>> iniciarVideo = Rxn();
  RxString url = ''.obs;

  SolicitacaoOSCriacaoController() {
    formKey = GlobalKey<FormState>();
    solicitacao = SolicitacaoOSModel(
      filialOrigem: getFilial().id_filial,
      dataEmissao: DateTime.now(),
      complemento: SolicitacaoOSComplementoEnum.ESTOQUE,
      imagens: [],
      videos: [],
    ).obs;
    filialRetransfTextController = TextEditingController();
    solicitacaoOSRepository = SolicitacaoOSRepository();
    defeitoOSRepository = DefeitoOSRepository();
    checklistOSRepository = ChecklistOSRepository();

    formFiltragemProdutosKey = GlobalKey<FormState>();
    produtoOSRepository = ProdutoOSRepository();
    paginaProdutos = PaginaModel(
      atual: 1,
      total: 0,
    );

    produtos = <ProdutoOSModel>[];

    defeitos = <DefeitoOSModel>[];

    checklists = <ChecklistOSModel>[];

    maskFormatter = MaskFormatter();
    formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    checkBoxCategoriaImagem = null;
    controllerVideo.value = VideoPlayerController.network('${url.value}');
    // iniciarVideo.value = controllerVideo.value!.initialize();
    controllerVideo.value!.setLooping(true);
  }

  /// Função responsável por buscar a filial de retransferência referente
  /// a filial de origem informada pelo usuário.
  Future<void> buscarFilialRetransferencia() async {
    try {
      if (solicitacao.value.filialDestino != null &&
          !solicitacao.value.filialDestino!.isEmpty) {
        String filialRetransferencia = await solicitacaoOSRepository
            .buscarFilialRetransferencia(solicitacao.value.filialDestino);

        filialRetransfTextController.text = filialRetransferencia;
      }
    } catch (e) {
      String errorMessage = e.toString();

      // Caso a mensagem de erro seja referente a filial não encontrada, então não exibe a notificação
      if (!errorMessage.toLowerCase().contains('nenhuma filial')) {
        Notificacao.snackBar(
          e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error,
        );
      }

      filialRetransfTextController.text = '';
    }
  }

  /// Função reponsável por buscar os produtos que podem ser adicionados na
  /// solicitação da OS.
  Future<void> buscarProdutos() async {
    try {
      carregandoProdutos(true);

      var retorno = await produtoOSRepository.buscarProdutos(
          pagina: this.paginaProdutos.atual,
          filial: getFilial().id_filial!,
          ld: this.ldProdutoFiltro,
          buscar: this.buscarProdutoFiltro);

      this.produtos = retorno[0];
      this.paginaProdutos = retorno[1];
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoProdutos(false);
      update();
    }
  }

  /// Função reponsável por selecionar o produto clicado/tocado pelo usuário.
  void selecionarProduto(String codigo) {
    codigoProdutoSelecionado.value = codigo;
    update();
  }

  /// Função reponsável por confirmar a seleção do produto pelo usuário.
  void confirmarSelecaoProduto() async {
    if (codigoProdutoSelecionado.value == '') {
      Notificacao.snackBar('Selecione um produto antes de confirmar!',
          tipoNotificacao: TipoNotificacaoEnum.error);
    } else {
      ProdutoOSModel produtoSelecionado = produtos.firstWhere(
          (item) => item.idProduto == codigoProdutoSelecionado.value);
      solicitacao.update((value) {
        value?.itemSolicitacao = ItemSolicitacaoOSModel(
          idProduto: produtoSelecionado.idProduto,
          idLd: produtoSelecionado.idLd,
          idDepartamento: produtoSelecionado.idDepartamento,
          idGrupo: produtoSelecionado.idGrupo,
          idCor: produtoSelecionado.idCor,
          nomeProduto: produtoSelecionado.denominacao,
          estoque: produtoSelecionado.saldoDisponivel,
          valor: double.tryParse(produtoSelecionado.custoMedio ?? ''),
          defeitos: [],
          checklists: [],
        );
      });

      await this.buscarDefeitosChecklists();
    }
  }

  /// Função reponsável por remover o produto selecionado pelo usuário.
  void removerProdutoSelecionado() {
    codigoProdutoSelecionado.value = '';

    solicitacao.update((value) {
      value?.itemSolicitacao = null;
    });
  }

  /// Função reponsável por buscar os defeitos e os checklists relacionados
  /// ao produto selecionado.
  Future<void> buscarDefeitosChecklists() async {
    try {
      carregandoDefeitosChecklists(true);

      this.defeitos = await defeitoOSRepository.buscarDefeitos(
          idProduto: this.solicitacao.value.itemSolicitacao!.idProduto!);

      this.checklists = await checklistOSRepository.buscarChecklists(
          idProduto: this.solicitacao.value.itemSolicitacao!.idProduto!);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoDefeitosChecklists(false);
    }
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
          }

          novasImagens.addAll(imagensSelecionadas);
        }
      }

      List<ImagemOSModel> novasImagensOs = await Future.wait(
        novasImagens.map((imagem) async {
          if (kIsWeb) {
            return ImagemOSModel(
              nome: imagem.name,
              base64: base64Encode(await imagem.readAsBytes()),
              url: imagem.path,
              categoria: checkBoxCategoriaImagem?.value.toString(),
            );
          }

          // Caso seja no app mobile, é necessário utilizar essa biblioteca
          // pois, por algum motivo, a imagem vem com a rotação errada
          return ImagemOSModel(
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
      if (solicitacao.value.imagens!.isEmpty) {
        solicitacao.update((value) {
          value!.imagens = novasImagensOs;
          selecionandoImagens.value = false;
        });
      } else {
        // Caso contrário, é necessário verificar a quantidade de imagens já selecionadas
        int tamanho = 0;
        for (ImagemOSModel i in solicitacao.value.imagens!) {
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

        solicitacao.update((value) {
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

  /// Função reponsável por remover a imagem selecionada pelo usuário.
  void removerImagemSelecionada(int index) {
    solicitacao.update((value) {
      value!.imagens!.removeAt(index);
    });
  }

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

      List<VideoOsModel> novosVideosOS = await Future.wait(
        novosVideos.map((video) async {
          if (kIsWeb) {
            return VideoOsModel(
              nome: video.name,
              base64: base64Encode(await video.readAsBytes()),
              url: video.path,
            );
          }

          // Caso seja no app mobile, é necessário utilizar essa biblioteca
          // pois, por algum motivo, o video vem com a rotação errada
          return VideoOsModel(
            nome: video.name,
            base64: base64Encode(await video.readAsBytes()),
            url: video.path,
          );
        }).toList(),
      );

      // Caso o usuário ainda não tenha selecionado nenhum video, adiciona todos os videos selecionados
      if (solicitacao.value.videos!.isEmpty) {
        solicitacao.update((value) {
          value!.videos = novosVideosOS;
        });
        url.value = solicitacao.value.videos!.first.url!.toString();
        controllerVideo.value =
            VideoPlayerController.network('${url.value.toString()}');
        iniciarVideo.value = controllerVideo.value!.initialize();
        controllerVideo.value!.setLooping(true);
      } else {
        // Caso contrário, é necessário verificar a quantidade de videos já selecionados
        if (solicitacao.value.videos!.length + novosVideos.length > 1) {
          Notificacao.snackBar(
            'Selecione, no máximo, 1 video!',
            tipoNotificacao: TipoNotificacaoEnum.error,
          );

          return;
        }

        solicitacao.update((value) {
          value!.videos!.addAll(novosVideosOS);
        });
      }
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
    }
  }

  // /// Função reponsável por remover o video selecionado pelo usuário.
  void removerVideoSelecionado(int index) {
    solicitacao.update((value) {
      value!.videos!.removeAt(index);
    });
  }

  /// Função reponsável por adicionar mais um campo de digitalização na tela
  /// para que o usuário possa preenchê-lo.
  void adicionarDigitalizacao() {
    solicitacao.update((value) {
      value!.digitalizacoes!.add(
        DigitalizacaoOSModel(),
      );
    });
  }

  /// Função reponsável por lidar com a seleção da imagem da digitalização
  /// referente a solicitação da OS.
  Future<void> escolherImagemDigitalizacao(int index,
      {ImageSource? origem}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? imagemSelecionada = await picker.pickImage(
        source: origem ?? ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );

      if (imagemSelecionada != null) {
        // Verifica o formato da imagem selecionada
        String nomeArquivo = imagemSelecionada.name;
        String formatoArquivo = nomeArquivo.split('.').last.toLowerCase();
        bool formatoInvalido = !['jpg', 'jpeg', 'png'].contains(formatoArquivo);

        if (formatoInvalido) {
          Notificacao.snackBar(
            'Selecione uma imagem válida!',
            tipoNotificacao: TipoNotificacaoEnum.error,
          );

          return;
        }

        String? base64;

        if (kIsWeb) {
          base64 = base64Encode(await imagemSelecionada.readAsBytes());
        } else {
          // Caso seja no app mobile, é necessário utilizar essa biblioteca
          // pois, por algum motivo, a imagem vem com a rotação errada
          base64 = base64Encode(
            await FlutterImageCompress.compressWithFile(
                  imagemSelecionada.path,
                  rotate: 0,
                  quality: 90,
                  keepExif: false,
                  autoCorrectionAngle: true,
                  format: CompressFormat.jpeg,
                ) ??
                [],
          );
        }

        solicitacao.update((value) {
          value!.digitalizacoes?[index].nomeImagem = nomeArquivo;
          value.digitalizacoes?[index].base64 = base64;
        });
      }
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
    }
  }

  /// Função reponsável por remover a imagem da digitalização selecionada
  /// pelo usuário.
  void removerImagemDigitalizacao(int index) {
    solicitacao.update((value) {
      value!.digitalizacoes![index].nomeImagem = null;
      value.digitalizacoes![index].base64 = null;
    });
  }

  /// Função reponsável por remover a digitalização selecionada pelo usuário.
  void removerDigitalizacao(int index) {
    solicitacao.update((value) {
      value!.digitalizacoes!.removeAt(index);
    });
  }

  /// Função reponsável por validar todos os campos da tela.
  bool validarCamposSolicitacao() {
    // Verifica se a filial de destino foi informada
    if (solicitacao.value.filialDestino == null ||
        solicitacao.value.filialDestino!.isEmpty) {
      Notificacao.snackBar('Informe a filial de destino!',
          tipoNotificacao: TipoNotificacaoEnum.error);
      return false;
    }

    // Caso Complemento OS = TROCA CONSUMIDOR OU TROCA CENTRAL CLIENTE, algumas validações extras
    // são necessárias
    if (solicitacao.value.complemento! ==
            SolicitacaoOSComplementoEnum.TROCA_CONSUMIDOR ||
        solicitacao.value.complemento! ==
            SolicitacaoOSComplementoEnum.TROCA_CENTRAL_CLIENTE) {
      // Verifica se o CRM foi informado
      if (solicitacao.value.crm == null || solicitacao.value.crm!.isEmpty) {
        Notificacao.snackBar('Informe o CRM!',
            tipoNotificacao: TipoNotificacaoEnum.error);
        return false;
      }

      // Verifica se todos os campos da NF de Venda foram preenchidos
      if (solicitacao.value.filialSaidaVenda == null ||
          solicitacao.value.numDocFiscalVenda == null ||
          solicitacao.value.serieDocFiscalVenda == null ||
          solicitacao.value.serieDocFiscalVenda!.isEmpty ||
          solicitacao.value.dataEmissaoVenda == null ||
          solicitacao.value.dataEmissaoVenda! == '') {
        Notificacao.snackBar('Informe todos os campos da NF de Venda!',
            tipoNotificacao: TipoNotificacaoEnum.error);
        return false;
      }

      // Caso Categoria Troca = TROCA, algumas validações extras
      // são necessárias
      if (solicitacao.value.categoriaTroca! ==
          SolicitacaoOSCategoriaTrocaEnum.TROCA) {
        // Verifica se todos os campos da NF de Troca foram preenchidos
        if (solicitacao.value.filialSaidaTroca == null ||
            solicitacao.value.numDocFiscalTroca == null ||
            solicitacao.value.serieDocFiscalTroca == null ||
            solicitacao.value.serieDocFiscalTroca!.isEmpty ||
            solicitacao.value.dataEmissaoTroca == null ||
            solicitacao.value.dataEmissaoTroca! == '') {
          Notificacao.snackBar('Informe todos os campos da NF de Troca!',
              tipoNotificacao: TipoNotificacaoEnum.error);
          return false;
        }
      }
    }

    // Verifica se o item da solicitação foi informado
    if (solicitacao.value.itemSolicitacao == null) {
      Notificacao.snackBar('Informe o produto!',
          tipoNotificacao: TipoNotificacaoEnum.error);
      return false;
    }

    // Verifica se o número de série do item da solicitação foi informado
    if (solicitacao.value.itemSolicitacao!.numeroSerie == null ||
        solicitacao.value.itemSolicitacao!.numeroSerie!.isEmpty) {
      Notificacao.snackBar('Informe o número de série do produto!',
          tipoNotificacao: TipoNotificacaoEnum.error);
      return false;
    }

    // Caso o produto tenha defeitos, é obrigatório informar oa menos um
    if (defeitos.length > 0) {
      // Verifica se os defeitos foram informados
      if (solicitacao.value.itemSolicitacao!.defeitos == null ||
          solicitacao.value.itemSolicitacao!.defeitos!.length == 0) {
        Notificacao.snackBar('Informe os defeitos do produto!',
            tipoNotificacao: TipoNotificacaoEnum.error);
        return false;
      }
    }

    // Caso o produto tenha checklists, é obrigatório informar oa menos um
    if (checklists.length > 0) {
      // Verifica se os itens do checklist foram informados
      if (solicitacao.value.itemSolicitacao!.checklists == null ||
          solicitacao.value.itemSolicitacao!.checklists!.length == 0) {
        Notificacao.snackBar('Informe os itens do checklist!',
            tipoNotificacao: TipoNotificacaoEnum.error);
        return false;
      }
    }

    // Verifica se as observações foram informadas
    if (solicitacao.value.itemSolicitacao!.observacao == null ||
        solicitacao.value.itemSolicitacao!.observacao!.isEmpty) {
      Notificacao.snackBar('Informe as observações!',
          tipoNotificacao: TipoNotificacaoEnum.error);
      return false;
    }

    //verifica se possui video anexado
    if (solicitacao.value.videos!.isEmpty) {
      Notificacao.snackBar('É necessário anexar um vídeo antes de salvar',
          tipoNotificacao: TipoNotificacaoEnum.error);
      return false;
    }

    //chama a funcao para verificar a quantidade minima de imagens por categoria
    if (tamanhoMinimo()) {
      return false;
    }

    // Caso Complemento OS = JURÍDICO, algumas validações extras
    // são necessárias
    if (solicitacao.value.complemento! ==
        SolicitacaoOSComplementoEnum.JURIDICO) {
      bool digitalizacoesValidas = true;

      // Verifica se todas as digitalizações informadas foram preenchidas corretamente
      solicitacao.value.digitalizacoes?.forEach((digitalizacao) {
        if (digitalizacao.descricao == null ||
            digitalizacao.descricao!.isEmpty ||
            digitalizacao.base64 == null ||
            digitalizacao.base64!.isEmpty) {
          digitalizacoesValidas = false;
        }
      });

      if (!digitalizacoesValidas) {
        Notificacao.snackBar('Informe corretamente todas as digitalizações!',
            tipoNotificacao: TipoNotificacaoEnum.error);
        return false;
      }
    }

    return true;
  }

  /// Função reponsável por criar a solicitação da OS.
  Future<bool> criarSolicitacao() async {
    try {
      carregandoCriacao(true);

      return await solicitacaoOSRepository.criarSolicitacao(solicitacao.value);
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);

      return false;
    } finally {
      carregandoCriacao(false);
    }
  }

  /// Função de utilidade, responsável por fechar o modal e remover qualquer
  /// foco existente na tela.
  void fecharDialog() {
    Get.back();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  //Verifica o tamanho da lista para a categoria selecionada
  tamanhoLista(CategoriaImagensEnum? checkBoxCategoriaImagem) {
    int tamanho = 0;
    for (ImagemOSModel i in solicitacao.value.imagens!) {
      if (i.categoria == checkBoxCategoriaImagem!.value.toString()) {
        tamanho++;
      }
    }
    return tamanho;
  }

  //Função responsavel por atualizar o estado do checkbox
  checkBoxImagem(CategoriaImagensEnum? value) {
    checkBoxCategoriaImagem = value;
    update();
  }

  //Verifica a quantidade máxima de imagens selecionada
  verificalimiteImagens(CategoriaImagensEnum? checkBoxCategoriaImagem) {
    int imagensSelecionadas = 0;
    for (ImagemOSModel i in solicitacao.value.imagens!) {
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
    final List<ImagemOSModel> numeroSerie = solicitacao.value.imagens!
        .where((imagem) => imagem.categoria.toString() == '1')
        .toList();

    final List<ImagemOSModel> condicaoProduto = solicitacao.value.imagens!
        .where((imagem) => imagem.categoria.toString() == '2')
        .toList();

    final List<ImagemOSModel> defeitos = solicitacao.value.imagens!
        .where((imagem) => imagem.categoria.toString() == '3')
        .toList();

    if (numeroSerie.length < 1) {
      Notificacao.snackBar(
        'Selecione no minino 1 imagem para categoria Número Série',
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
      return true;
    }
    if (condicaoProduto.length < 1) {
      Notificacao.snackBar(
        'Selecione no minino 1 imagem para categoria Condição Produto',
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
      return true;
    }

    if (defeitos.length < 1) {
      Notificacao.snackBar(
        'Selecione no minino 1 imagem para categoria Defeitos',
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
      return true;
    }
    return false;
  }
}
