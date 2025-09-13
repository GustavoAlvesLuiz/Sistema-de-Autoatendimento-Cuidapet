import 'dart:io';

// Classe para representar um item genérico (Produto ou Serviço)
abstract class Item {
  final int codigo;
  final String nome;
  final double preco;

  Item(this.codigo, this.nome, this.preco);

  @override
  String toString() {
    return 'Código: $codigo | $nome - R\$ ${preco.toStringAsFixed(2)}';
  }
}

// Classe para Produtos
class Produto extends Item {
  Produto(int codigo, String nome, double preco) : super(codigo, nome, preco);
}

// Classe para Serviços
class Servico extends Item {
  Servico(int codigo, String nome, double preco) : super(codigo, nome, preco);
}

// Classe para gerenciar o estado global da aplicação
class Sistema {
  int totalClientesAtendidos = 0;
  double totalFaturadoDia = 0.0;
  final String senhaFuncionario = 'cuida123';

  // Listas de produtos e serviços disponíveis
  final List<Produto> produtos = [
    Produto(101, 'Ração Premium 1kg', 35.50),
    Produto(102, 'Brinquedo Mordedor', 15.00),
    Produto(103, 'Shampoo Antipulgas', 25.75),
    Produto(104, 'Coleira de Couro', 45.00),
  ];

  final List<Servico> servicos = [
    Servico(201, 'Banho e Tosa', 80.00),
    Servico(202, 'Consulta Veterinária', 120.00),
    Servico(203, 'Aplicação de Vacina', 75.00),
  ];

  // Singleton para garantir uma única instância do sistema
  static final Sistema _instance = Sistema._internal();
  factory Sistema() {
    return _instance;
  }
  Sistema._internal();
}

// Classe para o carrinho de compras de um cliente
class Carrinho {
  final List<Item> itens = [];
  final int limiteItens = 3;

  bool adicionarItem(Item item) {
    if (itens.length < limiteItens) {
      itens.add(item);
      print('\n✅ Item "${item.nome}" adicionado ao carrinho!');
      return true;
    } else {
      print(
          '\n❌ Erro: Você já atingiu o limite de $limiteItens itens no carrinho.');
      return false;
    }
  }

  void listarItens() {
    if (itens.isEmpty) {
      print('\n🛒 Seu carrinho está vazio.');
    } else {
      print('\n--- 🛒 Itens no seu Carrinho ---');
      double total = 0.0;
      for (var item in itens) {
        print('- ${item.nome} (R\$ ${item.preco.toStringAsFixed(2)})');
        total += item.preco;
      }
      print('---------------------------------');
      print('Total parcial: R\$ ${total.toStringAsFixed(2)}');
      print('---------------------------------');
    }
  }

  double calcularTotal() {
    double total = 0.0;
    for (var item in itens) {
      total += item.preco;
    }
    return total;
  }
}

// Funções de Utilidade e Validação

// Função para ler entrada do usuário de forma segura
String lerEntrada(String prompt) {
  stdout.write(prompt);
  return stdin.readLineSync() ?? '';
}

// Função para ler um número inteiro com validação
int lerInt(String prompt) {
  while (true) {
    try {
      return int.parse(lerEntrada(prompt));
    } catch (e) {
      print('❌ Entrada inválida. Por favor, digite um número inteiro.');
    }
  }
}

// Função para limpar o console
void limparTela() {
  if (Platform.isWindows) {
    stdout.write(Process.runSync("cls", [], runInShell: true).stdout);
  } else {
    stdout.write(Process.runSync("clear", [], runInShell: true).stdout);
  }
}

// Funções Principais do Sistema

void main() {
  final sistema = Sistema();
  print('--- Sistema de Autoatendimento Cuidapet ---');
  print('---       Inicializando...           ---');
  sleep(Duration(seconds: 2));

  while (true) {
    limparTela();
    print('=============================================');
    print('🐾 Bem-vindo ao menu principal da Cuidapet 🐾');
    print('=============================================');
    print('1 - Iniciar novo atendimento (Cliente)');
    print('2 - Acessar área restrita (Funcionário)');
    print('0 - Encerrar sistema e ver relatório');

    int opcao = lerInt('\nEscolha uma opção: ');

    switch (opcao) {
      case 1:
        iniciarAtendimentoCliente();
        break;
      case 2:
        acessarAreaRestrita();
        break;
      case 0:
        exibirRelatorioFinal();
        return; // Encerra o programa
      default:
        print('❌ Opção inválida. Tente novamente.');
        sleep(Duration(seconds: 2));
    }
  }
}

// Fluxo de Atendimento ao Cliente
void iniciarAtendimentoCliente() {
  limparTela();
  final sistema = Sistema();
  final carrinho = Carrinho();

  String nomeCliente = lerEntrada('Olá! Para começar, qual o seu nome? ');
  while (nomeCliente.trim().isEmpty) {
    print('❌ Nome inválido. Por favor, digite seu nome.');
    nomeCliente = lerEntrada('Qual o seu nome? ');
  }

  sistema.totalClientesAtendidos++;

  limparTela();
  print('🐶 Olá, $nomeCliente! Seja bem-vindo(a) à Cuidapet. 🐱\n');

  bool clienteAtivo = true;
  while (clienteAtivo) {
    exibirMenuPrincipal();
    int escolha = lerInt('Escolha uma opção: ');

    switch (escolha) {
      case 1:
        verPromocoes(carrinho);
        break;
      case 2:
        solicitarServicos(carrinho);
        break;
      case 3:
        carrinho.listarItens();
        break;
      case 4:
        finalizarCarrinho(carrinho, nomeCliente);
        clienteAtivo = false; // Finaliza o loop para este cliente
        break;
      case 0:
        print('\nAtendimento cancelado. Até a próxima, $nomeCliente!');
        clienteAtivo = false;
        break;
      default:
        print('❌ Opção inválida. Por favor, tente novamente.');
    }
    if (clienteAtivo) {
      lerEntrada('\nPressione Enter para continuar...');
      limparTela();
    }
  }
  sleep(Duration(seconds: 3));
}

void exibirMenuPrincipal() {
  print('\n--- Menu Principal ---');
  print('1. Ver promoções de produtos');
  print('2. Solicitar serviços');
  print('3. Listar carrinho de compra');
  print('4. Finalizar carrinho');
  print('0. Sair / Cancelar atendimento');
}

void verPromocoes(Carrinho carrinho) {
  final sistema = Sistema();
  print('\n--- 🏷️ Nossas Promoções de Produtos ---');
  sistema.produtos.forEach(print);
  print('------------------------------------');

  if (carrinho.itens.length >= carrinho.limiteItens) {
    print('Seu carrinho está cheio. Finalize a compra para adicionar mais itens.');
    return;
  }

  int codigo =
      lerInt('Digite o código do produto para adicionar ao carrinho (ou 0 para voltar): ');
  if (codigo == 0) return;

  var produto = sistema.produtos
      .firstWhere((p) => p.codigo == codigo, orElse: () => Produto(-1, '', 0.0));

  if (produto.codigo != -1) {
    carrinho.adicionarItem(produto);
  } else {
    print('❌ Código de produto inválido.');
  }
}

void solicitarServicos(Carrinho carrinho) {
  final sistema = Sistema();
  print('\n--- 🛠️ Nossos Serviços ---');
  sistema.servicos.forEach(print);
  print('--------------------------');

  if (carrinho.itens.length >= carrinho.limiteItens) {
    print('Seu carrinho está cheio. Finalize a compra para adicionar mais itens.');
    return;
  }

  int codigo =
      lerInt('Digite o código do serviço para adicionar ao carrinho (ou 0 para voltar): ');
  if (codigo == 0) return;

  var servico = sistema.servicos
      .firstWhere((s) => s.codigo == codigo, orElse: () => Servico(-1, '', 0.0));

  if (servico.codigo != -1) {
    carrinho.adicionarItem(servico);
  } else {
    print('❌ Código de serviço inválido.');
  }
}

void finalizarCarrinho(Carrinho carrinho, String nomeCliente) {
  if (carrinho.itens.isEmpty) {
    print('\n❌ Seu carrinho está vazio! Adicione itens antes de finalizar.');
    return;
  }

  limparTela();
  print('\n--- Finalizando Compra ---');
  carrinho.listarItens();
  double total = carrinho.calcularTotal();
  double totalComDesconto = total;

  while (true) {
    print('\nFormas de Pagamento:');
    print('1 - Dinheiro (10% de desconto)');
    print('2 - Cartão de Crédito/Débito');
    print('3 - PIX');
    int formaPagamento = lerInt('Escolha a forma de pagamento: ');

    if (formaPagamento == 1) {
      totalComDesconto = total * 0.90;
      print('✅ Desconto de 10% aplicado!');
      break;
    } else if (formaPagamento == 2) {
      break;
    } else if (formaPagamento == 3) {
      break;
    } else {
      print('❌ Opção de pagamento inválida.');
    }
  }

  print('\n---------------------------------');
  print('Total da compra: R\$ ${total.toStringAsFixed(2)}');
  print('Total a pagar: R\$ ${totalComDesconto.toStringAsFixed(2)}');
  print('---------------------------------');

  // Adiciona ao faturamento do dia
  final sistema = Sistema();
  sistema.totalFaturadoDia += totalComDesconto;

  print('\nCompra finalizada com sucesso. A Cuidapet agradece a sua preferência!');
  print('Atendimento encerrado.');
}

// Área Restrita para Funcionários
void acessarAreaRestrita() {
  limparTela();
  final sistema = Sistema();
  String senha = lerEntrada('Digite a senha de acesso: ');

  if (senha == sistema.senhaFuncionario) {
    print('\n✅ Acesso permitido. Bem-vindo, funcionário!');
    sleep(Duration(seconds: 2));
    limparTela();

    print('--- Área Restrita - Lançamento Manual de Venda ---');

    // Simula um lançamento rápido
    String nomeCliente = lerEntrada('Nome do cliente: ');
    double valorCompra = 0.0;
    while (true) {
      try {
        valorCompra =
            double.parse(lerEntrada('Valor da compra: R\$ '));
        if (valorCompra > 0) break;
        print('❌ O valor deve ser positivo.');
      } catch (e) {
        print(
            '❌ Valor inválido. Use ponto como separador decimal (ex: 50.75).');
      }
    }

    double valorFinal = valorCompra;
    String formaPagamentoStr = '';

    while (true) {
      print('\nFormas de Pagamento:');
      print('1 - Dinheiro (10% de desconto)');
      print('2 - Cartão de Crédito/Débito');
      print('3 - PIX');
      int formaPagamento = lerInt('Forma de pagamento: ');

      if (formaPagamento == 1) {
        valorFinal = valorCompra * 0.9;
        formaPagamentoStr = 'Dinheiro';
        print(
            '✅ Desconto de 10% aplicado. Valor final: R\$ ${valorFinal.toStringAsFixed(2)}');
        break;
      } else if (formaPagamento == 2) {
        formaPagamentoStr = 'Cartão';
        break;
      } else if (formaPagamento == 3) {
        formaPagamentoStr = 'PIX';
        break;
      } else {
        print('❌ Opção inválida.');
      }
    }

    sistema.totalFaturadoDia += valorFinal;
    sistema.totalClientesAtendidos++;
    print(
        '\n✅ Venda para "$nomeCliente" no valor de R\$ ${valorFinal.toStringAsFixed(2)} ($formaPagamentoStr) registrada com sucesso!');

  } else {
    print('❌ Senha incorreta. Acesso negado.');
  }
  lerEntrada('\nPressione Enter para voltar ao menu principal...');
}

// Relatório Final
void exibirRelatorioFinal() {
  limparTela();
  final sistema = Sistema();
  print('\n=============================================');
  print('         Relatório Final do Dia');
  print('=============================================');
  print('Encerrando o sistema...');
  print('Total de clientes atendidos: ${sistema.totalClientesAtendidos}');
  print('Total faturado no dia: R\$ ${sistema.totalFaturadoDia.toStringAsFixed(2)}');
  print('\nObrigado por usar o sistema Cuidapet!');
  print('=============================================');
}