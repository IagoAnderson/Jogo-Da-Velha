import 'dart:io';

class ItemTabuleiro {
  late int index;
  String simbolo = ' ';
  bool jogado = false;
  late int jogador;

  ItemTabuleiro(this.index, {simbolo, jogado, jogador});
}

class GameController {
  List<ItemTabuleiro> tabuleiro = [];
  int pontuacao_jogador1 = 0;
  int pontuacao_jogador2 = 0;
  List<int> movimentos_jogador1 = [];
  List<int> movimentos_jogador2 = [];
  int jogador_atual = 1;

  bool get aindaTemMovimentos =>
      (movimentos_jogador1.length + movimentos_jogador2.length) < 9;

  int checkGanhadores() {
    // Verificar linhas
    for (int i = 0; i < 9; i += 3) {
      if (tabuleiro[i].simbolo != ' ' &&
          tabuleiro[i].simbolo == tabuleiro[i + 1].simbolo &&
          tabuleiro[i].simbolo == tabuleiro[i + 2].simbolo) {
        return tabuleiro[i].jogador;
      }
    }

    // Verificar colunas
    for (int i = 0; i < 3; i++) {
      if (tabuleiro[i].simbolo != ' ' &&
          tabuleiro[i].simbolo == tabuleiro[i + 3].simbolo &&
          tabuleiro[i].simbolo == tabuleiro[i + 6].simbolo) {
        return tabuleiro[i].jogador;
      }
    }

    // Verificar diagonais
    if (tabuleiro[0].simbolo != ' ' &&
        tabuleiro[0].simbolo == tabuleiro[4].simbolo &&
        tabuleiro[0].simbolo == tabuleiro[8].simbolo) {
      return tabuleiro[0].jogador;
    }

    if (tabuleiro[2].simbolo != ' ' &&
        tabuleiro[2].simbolo == tabuleiro[4].simbolo &&
        tabuleiro[2].simbolo == tabuleiro[6].simbolo) {
      return tabuleiro[2].jogador;
    }

    return 0; // Nenhum vencedor ainda
  }

  void adicionarJogada(int index) {
    if (tabuleiro[index].jogado == true) {
      print("Este campo já foi jogado");
      return;
    }

    if (jogador_atual == 1) {
      movimentos_jogador1.add(index);
      tabuleiro[index].simbolo = "X";
    } else {
      movimentos_jogador2.add(index);
      tabuleiro[index].simbolo = "O";
    }

    tabuleiro[index].jogado = true;
    tabuleiro[index].jogador = jogador_atual;

    jogador_atual = 3 - jogador_atual; // Alternar entre jogador 1 e jogador 2
  }

  void inicializaTabuleiro() {
    tabuleiro =
        List<ItemTabuleiro>.generate(9, (index) => ItemTabuleiro(index));
  }

  void printTabuleiro() {
    for (var item in tabuleiro) {
      stdout.write(item.simbolo);
      if (item.index == 2 || item.index == 5 || item.index == 8) {
        print("\n");
      } else {
        stdout.write("|");
      }
    }
  }
}

void main() {
  GameController game = GameController();
  game.inicializaTabuleiro();
  game.printTabuleiro();

  while (game.aindaTemMovimentos) {
    print("Entre com a posição de jogo:");
    String? jogada = stdin.readLineSync();
    if (jogada != null) {
      try {
        int index = int.parse(jogada);
        if (index >= 0 && index < 9) {
          game.adicionarJogada(index);
          game.printTabuleiro();

          int vencedor = game.checkGanhadores();
          if (vencedor != 0) {
            print("Jogador $vencedor venceu!");
            break; // Encerrar o loop se houver um vencedor
          }
        } else {
          print("Posição inválida. Digite um número de 0 a 8.");
        }
      } catch (e) {
        print("Entrada inválida. Digite um número de 0 a 8.");
      }
    }
  }
  print("Fim do jogo!");
  game.printTabuleiro();
}
