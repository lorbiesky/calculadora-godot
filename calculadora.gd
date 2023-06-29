extends CanvasLayer

const MAX_DISPLAY_LENGTH = 10

@onready var botoes = get_tree().get_nodes_in_group("button")
@onready var display_text = $ColorRect/MarginContainer/VBoxContainer/DisplayText
@onready var historico_text = $HistoricoText

var number_a: float
var number_b: float
var operador: String

func _ready() -> void:
	display_text.text = "0"
	
	for botao in botoes:
		botao.pressed.connect(botao_pressionado.bind(botao.name))

func botao_pressionado(nome_do_botao: String) -> void:
	match nome_do_botao:
		"Reset":
			resetar()
		"Apagar":
			apagar()
		"Virg":
			if display_text.text.length() < MAX_DISPLAY_LENGTH:
				adicionar_virgula()
		_:
			if display_text.text.length() < MAX_DISPLAY_LENGTH:
				identificar_outros_botoes(nome_do_botao)


func adicionar_numero(numero: String) -> void:
	if display_text.text == "0" or display_text.text.length() >= MAX_DISPLAY_LENGTH:
		display_text.text = numero
	else:
		display_text.text += numero

func adicionar_virgula() -> void:
	if !display_text.text.contains("."):
		display_text.text += "."

func adicionar_expressao(operador: String) -> void:
	if !display_text.text.ends_with(",") and historico_text.text.is_empty():
		historico_text.text = display_text.text + operador
		display_text.text = "0"

func resetar() -> void:
	display_text.text = "0"
	historico_text.text = ""

func apagar() -> void:
	if display_text.text.length() > 1:
		display_text.text = display_text.text.substr(0, display_text.text.length() - 1)
	else:
		display_text.text = "0"

func identificar_outros_botoes(nome_botao: String) -> void:
	if nome_botao.is_valid_int() or nome_botao == "Virg":
		adicionar_numero(nome_botao)
	else:
		match nome_botao:
			"Som":
				adicionar_expressao("+")
			"Sub":
				adicionar_expressao("-")
			"Mult":
				adicionar_expressao("*")
			"Div":
				adicionar_expressao("/")
			"Igual":
				calcular_resultado()

func calcular_resultado() -> void:
	if historico_text.text.is_empty():
		return
		
	var expressao = historico_text.text
	operador = expressao[-1]
	expressao = expressao.substr(0, expressao.length() - 1)
	
	number_a = float(expressao)
	number_b = float(display_text.text)
	
	var resultado: float
	
	match historico_text.text[-1]:
		"+":
			resultado = number_a + number_b
		"-":
			resultado = number_a - number_b
		"*":
			resultado = number_a * number_b
		"/":
			if number_b != 0:
				resultado = number_a / number_b
			else:
				display_text.text = "Erro"
				return
	
	display_text.text = str(resultado)
	historico_text.text = ""

	if display_text.text.length() > MAX_DISPLAY_LENGTH:
		display_text.text = display_text.text.substr(0, MAX_DISPLAY_LENGTH)
	
