# PseudoEngine

Um projeto experimental de uma "game engine" programada na pseudo-linguagem de programação Portugol. Possui as ferramentas básicas que uma game engine deve possuir para que um jogo possa ser desenvolvido, como sistema de objetos, lifecycle, components, inputs, time e outros utilitários.

## Como executar

- É necessário ter o Portugol Studio instalado na máquina, que pode ser baixado pelo [repositório oficial no GitHub](https://univali-lite.github.io/Portugol-Studio/).
- Clone o repositório e abra o arquivo `Engine.por` usando o Portugol Studio.
- Na linha 16, altere o valor de `DIRECTORY` para o diretório onde o repositório foi clonado. Mantenha `Assets/` ao final do caminho para que o programa consiga localizar a pasta de assets.
- Execute o programa pelo Portugol Studio.

## Organização, Padrões e Instruções

- O código é divido em seções, que são definidas por duas linhas do tipo `//==================== EXEMPLO ====================`, todo o código entre essas linhas pertence àquela seção;
- Na seção `CONFIG` estão constantes que podem ser personalizadas de acordo com o que você preferir para a execução do código;
- Na seção `CONFIG` há uma constante chamada `OBJECTS_COUNT` nela deve ser colocado o número de objetos diferentes criados, existem 3 objetos por padrão da engine (Entity, Renderer, Collider) então sempre coloque: 3 + número de objetos criados por você (inicialmente está definido com 4 por conta do código de exemplo que possui o objeto `PLAYER`);
- A constante `TICK` da `CONFIG` guarda quanto tempo deve ser aguardado em milissegundos entre cada frame, usado para limitar o FPS (deixe 0 para executar o máximo de vezes possível);
- Não utilize o caractere que estiver armazenado na constante `SEPARATOR` da seção `CONSTS` em strings. Pois a não utilização dele em strings é algo que o código da engine assume e precisa que seja verdadeiro para o funcionamento da LIST (fundamental para todo o funcionamento da engine);
- Existem duas estruturas especiais, `Vector2` (posição no plano cartesiano) e `Bounds` (cantos de um retângulo), eles são armazenados como um array, de tamanho 2 e 4 respectivamente, e por padrão, possuem seus índices associados a elementos daquela estrutura de dados, isso está definido nas constantes `X` e `Y` (para acesso do `Vector2`) e `LEFT`, `RIGHT`, `UP` e `DOWN` (para acesso do `Bounds`);
- Na seção `CONFIG` está permitido alterar os valores das constantes, na `LIFECYCLE` está permitindo adicionar código dentro do escopo das funções já declaradas, e na seção `GAME` está permitido adicionar o código que quiser (nele será escrito a implementação do jogo que será criado utilizando a engine). De resto, não adicione e nem altere nada em nenhuma outra seção para não quebrar o funcionamento da engine;
- No arquivo que está no repositório, existe uma implementação de um "jogo" feito utilizando a engine, ele pode ser apagado completamente respeitando as limitações do tópico anterior.
  
## Funcionalidades

### Utilitários e Conversões (Seções: `CONVERSION` e `UTILS`)
- `CONVERSION` disponibiliza diversas funções que permitem converter qualquer tipo para string, e vice-versa, permite converter int para float, e outros tipos de conversões utéis;
- `UTILS` disponibiliza diversas funções utilitárias que realizam inúmeras tarefas diferentes, consulte a seção do código para saber exatamente as funções disponíveis.

### Lista dinamicamente dimensionada e de tipos dinâmicos (Seção: `LIST`)
Por conta das limitações do Portugol de arrays poderem armazenar somente um tipo, e serem estaticamente dimensionados que pra piorar só podem ser criados com tamanhos de constantes em tempo de compilação. 

A engine oferece um "objeto" que pode ser usado como uma lista que possui diversas funções utilitárias, incluindo:
- Adicionar e inserir itens em posições específicas;
- Remover itens por índice ou valor;
- Acessar e alterar itens;
- Obter intervalos da lista;
- Buscar itens e verificar sua existência;
- Limpar a lista;
- Obter a quantidade de itens;
- Ordenar a lista.

### Sistema de simulação de objetos (Seção: `OBJECTS`)
Portugol não oferece POO, então só é possível declarar variáveis, constantes e funções, por isso, a engine oferece funções utilitárias para simular objetos usando a lista que a própria engine oferece, usando os índices da lista como campos dos objetos.

(consulte o resto do código para entender como usar essas funções para implementar objetos próprios)

Dentre as funcionalidades disponíveis para utilizar objetos estão: 
- Criação de instâncias a partir de um tipo e quantidade de campos;
- Gerenciamento automático de referências das instâncias;
- Reutilização de referências de instâncias que foram descartadas;
- Descarte de instâncias;
- Acesso a instâncias através de seu tipo e referência;
- Acesso e alteração dos campos de uma instância através de índices;
- Verificação se um campo possui valor nulo;
- Representação de campos sem valor através de null;
- Obtenção das referências de todas as instâncias de um determinado tipo.

### Lifecycle (Seção: `LIFECYCLE`)

A engine possui um sistema de lifecycle que define pontos específicos da execução do jogo nos quais o código do usuário pode ser executado.

As funções disponíveis são:

- `lifecycle_start`: executada uma vez ao iniciar a engine;
- `lifecycle_update`: executada a cada atualização do jogo;
- `lifecycle_onKeyDown`: chamada quando uma tecla é pressionada;
- `lifecycle_onKeyUp`: chamada quando uma tecla é solta;
- `lifecycle_onCollisionEnter`: chamada quando dois colliders começam a colidir;
- `lifecycle_onCollisionExit`: chamada quando dois colliders deixam de colidir;
- `lifecycle_onCollisionStay`: chamada enquanto dois colliders permanecem em colisão.

As funções `lifecycle_start` e `lifecycle_update` executam, respectivamente, `gameStart` e `gameUpdate`, permitindo que a implementação do jogo seja mantida na seção `GAME`.

### Time (Seção: `TIME`)

A engine possui um sistema de controle de tempo que calcula o tempo decorrido entre os frames e disponibiliza informações relacionadas à execução do jogo.

Entre as informações disponibilizadas estão:

- Delta time em milissegundos (`time_deltaTimeMs`);
- Delta time em segundos (`time_deltaTime`);
- FPS do frame atual (`time_fps`);
- FPS do frame atual convertido para inteiro (`time_shortFps`);
- Média de FPS dos últimos 100 frames (`time_avarageFps`);
- Contagem de frames executados (`time_currentFrame`).

O delta time pode ser utilizado para tornar movimentações e outras operações dependentes do tempo de execução, evitando que sua velocidade dependa diretamente da quantidade de FPS.

### Input (Seção: `INPUT`)

A engine possui um sistema de input que permite consultar o estado das teclas e detectar eventos de pressionamento e soltura.

São disponibilizadas três formas de consulta:

- `input_IsKeyDown`: verifica se uma tecla está pressionada no frame atual;
- `input_FrameKeyDown`: verifica se uma tecla foi pressionada no frame atual;
- `input_FrameKeyUp`: verifica se uma tecla foi solta no frame atual.

Além das consultas, o sistema de input também invoca automaticamente as funções `lifecycle_onKeyDown` e `lifecycle_onKeyUp` quando os respectivos eventos ocorrem.

### Entity (Seção: `ENTITY`)

`ENTITY` é o objeto base utilizado para representar entidades dentro do jogo. Cada entidade possui um estado de ativação, uma posição, um deslocamento e pode possuir um `COLLIDER` associado.

Entre as funcionalidades disponíveis estão:

- Criação e descarte de entidades;
- Ativação e desativação de entidades;
- Acesso e alteração da posição;
- Acesso e alteração do deslocamento;
- Movimentação através da aplicação de deslocamentos;
- Associação com um Collider;
- Acesso e alteração do Collider associado;
- Atualização automática da posição a cada frame.

A posição e o deslocamento das entidades são representados por `Vector2`. O deslocamento acumulado durante o frame é aplicado à posição da entidade durante a atualização da engine, sendo também considerado o deslocamento gerado pelo sistema de colisões.

### Renderer (Seção: `RENDERER`)

`RENDERER` é o objeto responsável por representar visualmente uma `ENTITY` na janela. Ele utiliza uma imagem carregada dos assets, redimensiona o sprite de acordo com o tamanho definido e desenha a imagem na posição da entidade.

Entre as funcionalidades disponíveis estão:

- Criação e descarte de renderers;
- Ativação e desativação da renderização;
- Associação com uma Entity;
- Definição e alteração da imagem utilizada;
- Definição e alteração do tamanho da imagem;
- Definição da camada de renderização;
- Recarregamento automático do sprite quando sua imagem ou tamanho é alterado;
- Renderização automática das entidades ativas;
- Ordenação da renderização de acordo com a camada definida.

### Collider (Seção: `COLLIDER`)

Collider é o objeto responsável por definir uma área de colisão associada a uma Entity. Ele utiliza uma posição relativa à entidade, um tamanho e um deslocamento para determinar seus limites e permitir que o sistema de colisões detecte e resolva colisões.

Entre as funcionalidades disponíveis estão:

- Criação e descarte de colliders;
- Ativação e desativação de colliders;
- Associação com uma Entity;
- Definição e alteração do tamanho do collider;
- Definição e alteração do deslocamento em relação à entidade;
- Configuração do collider como trigger;
- Acesso à posição absoluta do collider;
- Obtenção dos limites (Bounds) do collider;
- Aplicação e gerenciamento de deslocamentos gerados pelo sistema de colisões;
- Configuração da exibição visual dos limites do collider para depuração.

Um Collider pode ser configurado como trigger, permitindo detectar colisões sem que elas sejam resolvidas fisicamente. Os colliders também podem ter seus limites exibidos na janela para facilitar a visualização e depuração do sistema de colisões.
