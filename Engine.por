programa
{
	// ==================== DIRETIVES ====================
	inclua biblioteca Graficos --> graphics
	inclua biblioteca Util --> utils
	inclua biblioteca Teclado --> k
	inclua biblioteca Tipos --> types
	inclua biblioteca Texto --> text
	inclua biblioteca Matematica --> math
	// ==================== DIRETIVES ====================

	// ==================== CONFIG ====================
	const inteiro WINDOW_SIZE[] = {1280, 720}
	const cadeia WINDOW_NAME = "Game"
	
	const cadeia DIRECTORY = "Disco/Pasta/Repositorio/Assets/"
	
	const inteiro TICK = 0
	const inteiro OBJECTS_COUNT = 4
	// ==================== CONFIG ====================

	// ==================== CONSTS ====================
	const inteiro FRAMES_DELAY = 10
	
	const cadeia SEPARATOR = "|"
	const cadeia LIST_SEPARATOR = "="
	const cadeia OBJECT_SEPARATOR = ":"
	const cadeia INSTANCES_SEPARATOR = "/"
	const cadeia TYPES_SEPARATOR = ";"
	
	const inteiro X = 0
	const inteiro Y = 1

	const inteiro LEFT = 0
	const inteiro RIGHT = 1
	const inteiro UP = 2
	const inteiro DOWN = 3
	// ==================== CONSTS ====================

	// ==================== ENGINE CORE ====================	
	funcao inicio()
	{
		engine_createWindow(WINDOW_SIZE, WINDOW_NAME)
		engine_start()
		enquanto (verdadeiro) {
			engine_loop()
			utils.aguarde(TICK)
		}
	}

	funcao engine_createWindow(inteiro windowSize[], cadeia windowName) {
  		graphics.iniciar_modo_grafico(verdadeiro)
    		graphics.definir_dimensoes_janela(windowSize[X], windowSize[Y])
    		graphics.definir_titulo_janela(windowName)
    		//graphics.entrar_modo_tela_cheia()
  	}

	funcao engine_loop() {
		se(nao time_update()) {
			retorne
		}

		se (time_currentFrame < FRAMES_DELAY) {
			retorne
		}
		
		engine_update()
    		engine_redrawWindow()
	}

	funcao engine_redrawWindow() {
  		graphics.definir_cor(graphics.COR_PRETO)
    		graphics.limpar()
    		graphics.definir_cor(graphics.COR_BRANCO)
    		engine_draw()
    		graphics.definir_cor(graphics.COR_VERDE)
    		collisionsManager_drawBounds()
    		graphics.renderizar()
  	}

  	funcao engine_start() {
  		objects_start()
  		lifecycle_start()
  	}

	funcao engine_update() {
		input_update()
		lifecycle_update()
		collisionsManager_update()
		entity_static_update()
	}

  	funcao engine_draw() {
		renderer_static_update()
  	}
	// ==================== ENGINE CORE ====================
	
	// ==================== TIME ====================
	const inteiro TIME_AVARAGE_LENGHT = 100
	inteiro time_lasts_fps[TIME_AVARAGE_LENGHT]
	inteiro time_avarageFps
	
	inteiro time_currentFrame = 0
	inteiro time_timeElapsed = 0
	inteiro time_deltaTimeMs = 0
	inteiro time_shortFps = 0
	real time_deltaTime = 0.0
	real time_fps = 0.0
	

	funcao logico time_update() {
		inteiro lastElapsedTime = time_timeElapsed
		time_timeElapsed = utils.tempo_decorrido()
		time_deltaTimeMs = time_timeElapsed - lastElapsedTime
		time_deltaTime = time_deltaTimeMs / 1000.0
		
		se (time_deltaTimeMs == 0) {
			retorne falso
		}
		time_currentFrame++
		
		time_fps = 1.0 / time_deltaTime
		time_shortFps = float_ToInt(time_fps)

		inteiro i = time_currentFrame % TIME_AVARAGE_LENGHT
		time_lasts_fps[i] = time_shortFps

		inteiro sum = 0
		para (inteiro k = 0; k < TIME_AVARAGE_LENGHT; k++) {
			sum += time_lasts_fps[k]
		}
		time_avarageFps = sum / TIME_AVARAGE_LENGHT
		
		retorne verdadeiro
	}
	// ==================== TIME ====================

	//==================== SPRITES ====================
	funcao inteiro sprites_load(cadeia image, inteiro size[]) {
		inteiro loadedSprite = graphics.carregar_imagem(image)
  		inteiro resizedSprite = graphics.redimensionar_imagem(loadedSprite, size[X], size[Y], falso)
  		
  		graphics.liberar_imagem(loadedSprite)
  		retorne resizedSprite
	}

	funcao sprites_dispose(inteiro sprite) {
		graphics.liberar_imagem(sprite)
	}

	funcao sprites_draw(inteiro sprite, inteiro position[]) {
		graphics.desenhar_imagem(
  			position[X], 
  			-position[Y], 
  			sprite
  		)
	}
	//==================== SPRITES ====================

	//==================== INPUT ====================
	const inteiro INPUT_KEYCODES[] = {
		k.TECLA_0, k.TECLA_1, k.TECLA_2, k.TECLA_3, k.TECLA_4, k.TECLA_5, k.TECLA_6, k.TECLA_7, k.TECLA_8, k.TECLA_9,
			
		k.TECLA_A, k.TECLA_B, k.TECLA_C, k.TECLA_D, k.TECLA_E, k.TECLA_F, k.TECLA_G, k.TECLA_H, k.TECLA_I, k.TECLA_J,
		k.TECLA_K, k.TECLA_L, k.TECLA_M, k.TECLA_N, k.TECLA_O, k.TECLA_P, k.TECLA_Q, k.TECLA_R, k.TECLA_S, k.TECLA_T,
		k.TECLA_U, k.TECLA_V, k.TECLA_W, k.TECLA_X, k.TECLA_Y, k.TECLA_Z,

		k.TECLA_F1, k.TECLA_F2, k.TECLA_F3, k.TECLA_F5, k.TECLA_F6, k.TECLA_F7, k.TECLA_F8, k.TECLA_F9, k.TECLA_F10,
		k.TECLA_F11, k.TECLA_F12,

		k.TECLA_SETA_ABAIXO, k.TECLA_SETA_ACIMA, k.TECLA_SETA_DIREITA, k.TECLA_SETA_ESQUERDA,

		k.TECLA_ALT, k.TECLA_BACKSPACE, k.TECLA_ENTER, k.TECLA_ESC, k.TECLA_ESPACO, k.TECLA_SHIFT, k.TECLA_TAB,
		k.TECLA_CONTROL,

		k.TECLA_ADICAO, k.TECLA_SUBTRACAO, k.TECLA_DIVISAO, k.TECLA_MULTIPLICACAO, k.TECLA_MENOS,
		
		k.TECLA_ABRE_COLCHETES,  k.TECLA_AJUDA,  k.TECLA_BARRA, k.TECLA_BARRA_INVERTIDA, k.TECLA_CANCELAR, k.TECLA_CAPS_LOCK,
		k.TECLA_DECIMAL, k.TECLA_DELETAR,  k.TECLA_END, k.TECLA_FECHA_COLCHETES, k.TECLA_HOME, k.TECLA_IGUAL, k.TECLA_INSERT,
		k.TECLA_PAGE_UP, k.TECLA_PAUSE, k.TECLA_PONTO_FINAL, k.TECLA_PONTO_VIRGULA, k.TECLA_PRINTSCREEN, k.TECLA_SCROLL_LOCK,
		k.TECLA_LIMPAR,  k.TECLA_NUM_LOCK, k.TECLA_NUM_SEPARADOR_DECIMAL, k.TECLA_PAGE_DOWN,
		k.TECLA_VIRGULA, k.TECLA_WINDOWS
	}
	
	cadeia input_frameDownKeys = list_New("=")
	cadeia input_frameUpKeys = list_New("=")
	cadeia input_downKeys = list_New("=")
	
	cadeia input_lastDownKeys = list_New("=")

	funcao input_update() {
		input_refreshDownKeys()
		input_refreshFrameDownKeys()
		input_refreshFrameUpKeys()
		input_invokeEvents()
	}

	funcao input_refreshDownKeys() {
		input_lastDownKeys = input_downKeys
		list_Clear(input_downKeys)
		
		para (inteiro i = 0; i < GetArrayLength_int(INPUT_KEYCODES); i++) {
			inteiro key = INPUT_KEYCODES[i]
			se (k.tecla_pressionada(key)) {
				list_Add(input_downKeys, int_ToString(key))
			}
		}
	}

	funcao input_refreshFrameDownKeys() {
		list_Clear(input_frameDownKeys)
		
		para (inteiro i = 0; i < list_Length(input_downKeys); i++) {
			cadeia key = list_GetAt(input_downKeys, i)
			se (nao list_Contains(input_lastDownKeys, key)) {
				list_Add(input_frameDownKeys, key)
			}
		}
	}

	funcao input_refreshFrameUpKeys() {
		list_Clear(input_frameUpKeys)
		
		para (inteiro i = 0; i < list_Length(input_lastDownKeys); i++) {
			cadeia key = list_GetAt(input_lastDownKeys, i)
			se (nao list_Contains(input_downKeys, key)) {
				list_Add(input_frameUpKeys, key)
			}
		}
	}

	funcao input_invokeEvents() {
		para (inteiro i = 0; i < list_Length(input_frameDownKeys); i++) {
			lifecycle_onKeyDown(
				string_ToInt(
					list_GetAt(
						input_frameDownKeys, i)))
		}

		para (inteiro i = 0; i < list_Length(input_frameUpKeys); i++) {
			lifecycle_onKeyUp(
				string_ToInt(
					list_GetAt(
						input_frameUpKeys, i)))
		}
	}
	
  	funcao logico input_IsKeyDown(inteiro key) {
  		retorne list_Contains(input_downKeys, int_ToString(key))
  	}

  	funcao logico input_FrameKeyDown(inteiro key) {
  		retorne list_Contains(input_frameDownKeys, int_ToString(key))
  	}

  	funcao logico input_FrameKeyUp(inteiro key) {
  		retorne list_Contains(input_frameUpKeys, int_ToString(key))
  	}
  	//==================== INPUT ====================

	//==================== OBJECTS ====================
	const cadeia OBJECTS_INSTANCE_SEPARATOR = "/"
	
	const inteiro OBJECTS_NULL_INSTANCE = -1
	const cadeia OBJECTS_FREE_INSTANCE = "free"
	const cadeia OBJECTS_NULL_FIELD = "null"

	cadeia objects_instances[OBJECTS_COUNT]
	
	funcao objects_start() {
		para (inteiro i = 0; i < OBJECTS_COUNT; i++) {
			objects_instances[i] = OBJECTS_INSTANCE_SEPARATOR + OBJECTS_FREE_INSTANCE
		}
	}

	funcao inteiro objects_NewInstance(inteiro type, inteiro fieldsCount) {
		inteiro reference = objects_GetFreeInstance(type)
		cadeia instance = list_New(OBJECT_SEPARATOR)
		
		para (inteiro i = 0; i < fieldsCount; i++) {
			list_Add(instance, OBJECTS_NULL_FIELD)
		}

		objects_SetInstance(type, reference, instance)
		retorne reference
	}

	funcao logico objects_IsFieldNull(inteiro type, inteiro reference, inteiro field) {
		retorne objects_GetField(type, reference, field) == OBJECTS_NULL_FIELD
	}

  	funcao objects_Dispose(inteiro type, inteiro reference) {
  		objects_SetInstance(type, reference, OBJECTS_FREE_INSTANCE)
  	}

  	funcao inteiro objects_GetFreeInstance(inteiro type) {
  		cadeia instances = objects_instances[type]
		inteiro length = list_Length(instances)
  		
  		para (inteiro i = 0; i < length; i++) {
  			se (list_GetAt(instances, i) == OBJECTS_FREE_INSTANCE) {
  				retorne i
  			}
  		}
  		
  		list_Add(instances, OBJECTS_FREE_INSTANCE)
  		objects_instances[type] = instances
  		retorne length
  	}

  	funcao cadeia objects_GetInstance(inteiro type, inteiro reference) {
  		cadeia instances = objects_instances[type]
  		retorne list_GetAt(instances, reference)
  	}

  	funcao objects_SetInstance(inteiro type, inteiro reference, cadeia newValue) {
  		cadeia instances = objects_instances[type]
  		list_Set(
  			instances, 
  			reference,
  			newValue
  		)
  		objects_instances[type] = instances
  	}

  	funcao cadeia objects_GetField(inteiro type, inteiro reference, inteiro field) {
  		cadeia instance = objects_GetInstance(type, reference)
  		retorne list_GetAt(instance, field)
  	}

  	funcao objects_SetField(inteiro type, inteiro reference, inteiro field, cadeia newValue) {
  		cadeia instance = objects_GetInstance(type, reference)
	     list_Set(instance, field, newValue)
	     objects_SetInstance(type, reference, instance)
  	}

  	funcao cadeia objects_GetAllInstanceReferences(inteiro type, cadeia separator) {
  		cadeia instances = objects_instances[type]
  		cadeia references = list_New(separator)
  		
  		para (inteiro i = 0; i < list_Length(instances); i++) {
  			se (list_GetAt(instances, i) == OBJECTS_FREE_INSTANCE) {
  				list_Add(references, int_ToString(OBJECTS_NULL_INSTANCE))
  			} senao {
  				list_Add(references, int_ToString(i))
  			}
  		}

		retorne references  		
  	}
	//==================== OBJECTS ====================

	//==================== ENTITY ====================
	const inteiro ENTITY_TYPE = 0
	const inteiro ENTITY_FIELDS_COUNT = 4

	const inteiro ENTITY_IS_ACTIVE = 0
  	const inteiro ENTITY_POSITION = 1
  	const inteiro ENTITY_DISPLACEMENT = 2
  	const inteiro ENTITY_COLLIDER = 3

  	funcao entity_static_update() {
  		cadeia transforms = objects_GetAllInstanceReferences(ENTITY_TYPE, LIST_SEPARATOR)
		inteiro lenght = list_Length(transforms)
		
		para (inteiro i = 0; i < lenght; i++) {
			inteiro reference = string_ToInt(list_GetAt(transforms, i))
			
			se (reference != OBJECTS_NULL_INSTANCE) {
				entity_applyMove(reference)
			}
		}
  	}

	funcao cadeia entity_getField(inteiro reference, inteiro field) {
		retorne objects_GetField(ENTITY_TYPE, reference, field)
	}

	funcao entity_setField(inteiro reference, inteiro field, cadeia value) {
		objects_SetField(ENTITY_TYPE, reference, field, value)
	}
	
	funcao inteiro entity_Instantiate(real position[]) {
		inteiro reference = objects_NewInstance(ENTITY_TYPE, ENTITY_FIELDS_COUNT)
		real displacement[] = { 0.0, 0.0 }

		entity_SetActive(reference, verdadeiro)
		entity_setPosition(reference, position)
		entity_setDisplacement(reference, displacement)
		
		retorne reference
	}

	funcao entity_Dispose(inteiro reference) {
		objects_Dispose(ENTITY_TYPE, reference)
	}

	funcao logico entity_IsActive(inteiro reference) {
		retorne string_ToBool(entity_getField(reference, ENTITY_IS_ACTIVE))
	}

	funcao entity_SetActive(inteiro reference, logico value) {
		entity_setField(
			reference, 
			ENTITY_IS_ACTIVE, 
			bool_ToString(value)
		)
	}

	funcao entity_GetPosition(inteiro reference, real &out[]) {
		cadeia stringPosition = entity_getField(reference, ENTITY_POSITION)
		string_ToVector2(stringPosition, out)
	}

	funcao entity_setPosition(inteiro reference, real value[]) {
		cadeia stringValue = vector2_ToString(value)
		entity_setField(reference, ENTITY_POSITION, stringValue)
	}

	funcao entity_GetDisplacement(inteiro reference, real &out[]) {
		cadeia stringPosition = entity_getField(reference, ENTITY_DISPLACEMENT)
		string_ToVector2(stringPosition, out)
	}

	funcao entity_setDisplacement(inteiro reference, real value[]) {
		cadeia stringValue = vector2_ToString(value)
		entity_setField(reference, ENTITY_DISPLACEMENT, stringValue)
	}

	funcao inteiro entity_GetCollider(inteiro reference) {
		cadeia stringCollider = entity_getField(reference, ENTITY_COLLIDER)
		se (stringCollider == OBJECTS_NULL_FIELD) {
			retorne OBJECTS_NULL_INSTANCE
		}
		retorne string_ToInt(stringCollider)
	}

	funcao entity_SetCollider(inteiro reference, inteiro collider) {
		entity_setField(
			reference, 
			ENTITY_COLLIDER, 
			int_ToString(collider)
		)
	}
	
	funcao entity_Move(inteiro reference, real value[]) {
		real currentDisplacement[2]
		entity_GetDisplacement(reference, currentDisplacement)

		real newDisplacement[] = {
			currentDisplacement[X] + value[X],
			currentDisplacement[Y] + value[Y]
		}

		entity_setDisplacement(reference, newDisplacement)
	}

	funcao entity_applyMove(inteiro reference) {
		real displacement[2]
		real currentPosition[2]
		real colDisplacement[] = {0.0, 0.0}

		entity_GetDisplacement(reference, displacement)
		entity_GetPosition(reference, currentPosition)
		
		real newDisplacement[] = { 0.0 , 0.0 }

		se (entity_GetCollider(reference) != OBJECTS_NULL_INSTANCE) {
			inteiro col = entity_GetCollider(reference)
			collider_getDisplacement(col, colDisplacement)
		}

		real newPosition[] = {
			currentPosition[X] + displacement[X] + colDisplacement[X],
			currentPosition[Y] + displacement[Y] + colDisplacement[Y]
		}
		
		entity_setPosition(reference, newPosition)
		entity_setDisplacement(reference, newDisplacement)
	}
	//==================== ENTITY ====================

	//==================== RENDERER ====================
	const inteiro RENDERER_TYPE = 1
	const inteiro RENDERER_FIELDS_COUNT = 6

	const inteiro RENDERER_IS_ACTIVE = 0
	const inteiro RENDERER_ENTITY = 1
  	const inteiro RENDERER_IMAGE = 2
  	const inteiro RENDERER_SIZE = 3
  	const inteiro RENDERER_LAYER = 4
  	const inteiro RENDERER_SPRITE = 5

  	funcao renderer_static_update() {
  		cadeia renderers = renderer_static_getSortedReferences()
		inteiro lenght = list_Length(renderers)

		para (inteiro i = 0; i < lenght; i++) {
			inteiro reference = string_ToInt(list_GetAt(renderers, i))
			se (reference != OBJECTS_NULL_INSTANCE) {
				se (renderer_ShouldRender(reference)) {
					renderer_render(reference)
				}
			}
		}
  	}

  	funcao cadeia renderer_static_getSortedReferences() {
		cadeia layers = ""
		cadeia references = ""
		cadeia sortedLayers = ""
		renderer_static_getInfoToSort(layers, references, sortedLayers)

		cadeia sortedReferences = list_New("=")
		para (inteiro i = 0; i < list_Length(sortedLayers); i++) {
			inteiro layer = string_ToInt(list_GetAt(sortedLayers, i))
			inteiro index = list_GetFirst(layers, int_ToString(layer))
			
			list_Add(
				sortedReferences, 
				list_GetAt(references, index)
			)

			list_RemoveAt(layers, index)
			list_RemoveAt(references, index)
		}

		retorne sortedReferences
  	}

  	funcao renderer_static_getInfoToSort(cadeia &outLayers, cadeia &outReferences, cadeia &outSortedLayers) {
  		cadeia renderers = objects_GetAllInstanceReferences(RENDERER_TYPE, "-")
		inteiro lenght = list_Length(renderers)

		outLayers = list_New("=")
		outReferences = list_New("=")
		
		para (inteiro i = 0; i < lenght; i++) {
			inteiro reference = string_ToInt(list_GetAt(renderers, i))
			
			se (reference != OBJECTS_NULL_INSTANCE) {
				inteiro layer = renderer_GetLayer(reference)
				
				list_Add(outLayers, int_ToString(layer))
				list_Add(outReferences, int_ToString(reference))
			}
		}

		outSortedLayers = outLayers
		list_Sort(outSortedLayers)
  	}

	funcao cadeia renderer_getField(inteiro reference, inteiro field) {
		retorne objects_GetField(RENDERER_TYPE, reference, field)
	}

	funcao renderer_setField(inteiro reference, inteiro field, cadeia value) {
		objects_SetField(RENDERER_TYPE, reference, field, value)
	}
	
	funcao inteiro renderer_Instantiate(inteiro entity, cadeia image, real size[], inteiro layer) {
		inteiro reference = objects_NewInstance(RENDERER_TYPE, RENDERER_FIELDS_COUNT)

		renderer_SetActive(reference, verdadeiro)
		renderer_SetEntity(reference, entity)
		renderer_SetImage(reference, image)
		renderer_SetSize(reference, size)
		renderer_SetLayer(reference, layer)
		renderer_reloadSprite(reference)

		retorne reference
	}

	funcao renderer_Dispose(inteiro reference) {
		sprites_dispose(renderer_GetSprite(reference))
		objects_Dispose(RENDERER_TYPE, reference)
	}

	funcao logico renderer_IsActive(inteiro reference) {
		retorne string_ToBool(renderer_getField(reference, RENDERER_IS_ACTIVE))
	}

	funcao renderer_SetActive(inteiro reference, logico value) {
		renderer_setField(
			reference, 
			RENDERER_IS_ACTIVE, 
			bool_ToString(value)
		)
	}

	funcao inteiro renderer_GetEntity(inteiro reference) {
		cadeia stringEntity = renderer_getField(reference, RENDERER_ENTITY)
		retorne string_ToInt(stringEntity)
	}

	funcao renderer_SetEntity(inteiro reference, inteiro newEntity) {
		renderer_setField(
			reference, 
			RENDERER_ENTITY, 
			int_ToString(newEntity)
		)
	}

	funcao cadeia renderer_GetImage(inteiro reference) {
		retorne renderer_getField(reference, RENDERER_IMAGE)
	}

	funcao renderer_SetImage(inteiro reference, cadeia value) {
		se (renderer_GetImage(reference) == value) {
			retorne
		}
		
		renderer_setField(reference, RENDERER_IMAGE, value)
		renderer_reloadSprite(reference)
	}

	funcao renderer_GetSize(inteiro reference, real &out[]) {
		cadeia stringSize = renderer_getField(reference, RENDERER_SIZE)
		string_ToVector2(stringSize, out)
	}

	funcao renderer_SetSize(inteiro reference, real value[]) {
		logico shouldReload = objects_IsFieldNull(RENDERER_TYPE, reference, RENDERER_SIZE)
		
		se (nao shouldReload) {
			inteiro newValueInt[2]
			real currentValue[2]
			inteiro currentValueInt[2]
			
			vector2_ToVector2Int(value, newValueInt)
			renderer_GetSize(reference, currentValue)
			vector2_ToVector2Int(currentValue, currentValueInt)
	
			shouldReload = newValueInt[X] != currentValueInt[X] ou newValueInt[Y] != currentValueInt[Y]
		}
		
		cadeia stringValue = vector2_ToString(value)
		renderer_setField(reference, RENDERER_SIZE, stringValue)

		se (shouldReload) {
			renderer_reloadSprite(reference)
		}
	}

	funcao inteiro renderer_GetLayer(inteiro reference) {
		retorne string_ToInt(renderer_getField(reference, RENDERER_LAYER))
	}

	funcao renderer_SetLayer(inteiro reference, inteiro value) {
		renderer_setField(
			reference, 
			RENDERER_LAYER, 
			int_ToString(value)
		)
	}

	funcao inteiro renderer_GetSprite(inteiro reference) {
		retorne string_ToInt(renderer_getField(reference, RENDERER_SPRITE))
	}

	funcao renderer_setSprite(inteiro reference, inteiro value) {
		renderer_setField(reference, RENDERER_SPRITE, int_ToString(value))
	}

	funcao logico renderer_ShouldRender(inteiro reference) {
		logico rendererIsActive = renderer_IsActive(reference)
		logico entityIsActive = entity_IsActive(renderer_GetEntity(reference))
		retorne rendererIsActive e entityIsActive
	}

	funcao renderer_reloadSprite(inteiro reference) {
		se (
			objects_IsFieldNull(RENDERER_TYPE, reference, RENDERER_IMAGE) ou 
			objects_IsFieldNull(RENDERER_TYPE, reference, RENDERER_SIZE)
		) {
			retorne
		}

		se (nao objects_IsFieldNull(RENDERER_TYPE, reference, RENDERER_SPRITE)) {
			sprites_dispose(renderer_GetSprite(reference))
		}
		
		
		cadeia image
		real size[2]
		inteiro intSize[2]

		image = renderer_GetImage(reference)
		renderer_GetSize(reference, size)
		vector2_ToVector2Int(size, intSize)
		
		inteiro newSprite = sprites_load(image, intSize)
		renderer_setSprite(reference, newSprite)
	}

	funcao renderer_render(inteiro reference) {
		inteiro sprite
		real position[2]

		sprite = renderer_GetSprite(reference)
		entity_GetPosition(
			renderer_GetEntity(reference), 
			position
		)

		inteiro drawPosition[2]
		vector2_ToVector2Int(position, drawPosition)
		
		sprites_draw(sprite, drawPosition)
	}
	//==================== RENDERER ====================

	//==================== COLLISIONS MANAGER ====================
  	cadeia collisionsManager_lastFrameCollisions = list_New("=")
  	cadeia collisionsManager_frameCollisions = list_New("=")
	cadeia collisionsManager_enterCollisions = list_New("=")
	cadeia collisionsManager_exitCollisions = list_New("=")

	funcao collisionsManager_update() {
  		cadeia instances = objects_GetAllInstanceReferences(COLLIDER_TYPE, "=")
  		collisionsManager_clearDisplacements(instances)
  		cadeia toVerify = collisionsManager_getPairsToVerify(instances)
  		
  		collisionsManager_lastFrameCollisions = collisionsManager_frameCollisions
  		collisionsManager_frameCollisions = collisionsManager_getPairsOnCollision(toVerify)

		cadeia toResolve = collisionsManager_getPairsToResolve(collisionsManager_frameCollisions)
  		collisionsManager_resolvePairs(toResolve)

  		collisionsManager_invokeEvents()
  	}

  	funcao collisionsManager_drawBounds() { //bounds draw
		cadeia instances = objects_GetAllInstanceReferences(COLLIDER_TYPE, "=")
		
  		para (inteiro i = 0; i < list_Length(instances); i++) {
  			inteiro ref = string_ToInt(list_GetAt(instances, i))
  			se (collider_ShouldShowBounds(ref)) {
  				real bounds[4]
  				collider_GetBounds(ref, bounds)
  				graphics.desenhar_retangulo(
  					float_ToInt(bounds[LEFT]), 
  					float_ToInt(-bounds[DOWN]), 
  					float_ToInt(bounds[RIGHT] - bounds[LEFT]), 
  					float_ToInt(bounds[UP] - bounds[DOWN]), 
  					falso, 
  					falso
  				)
  			}
  		}
  	}

  	funcao collisionsManager_clearDisplacements(cadeia instances) {
  		para (inteiro i = 0; i < list_Length(instances); i++) {
  			inteiro ref = string_ToInt(list_GetAt(instances, i))
  			collider_clearDisplacement(ref)
  		}
  	}

	funcao cadeia collisionsManager_getPairsToVerify(cadeia instances) {
  		inteiro length = list_Length(instances)
  		
  		cadeia pairs = list_New("=")
		para (inteiro a = 0; a < length; a++) {
  			para (inteiro b = length - 1; b > a; b--) {
  				inteiro aRef = string_ToInt(list_GetAt(instances, a))
  				inteiro bRef = string_ToInt(list_GetAt(instances, b))
  				
  				se (aRef != OBJECTS_NULL_INSTANCE e bRef != OBJECTS_NULL_INSTANCE) {
  					inteiro pair[] = {aRef, bRef}
  					vector2Int_SortAscending(pair)
  					list_Add(
  						pairs, 
  						vector2Int_ToString(pair)
  					)
  				}
  			}
  		}
  		retorne pairs
	}

	funcao cadeia collisionsManager_getPairsOnCollision(cadeia pairs) {
		cadeia onCollision = list_New("=")
		para (inteiro i = 0; i < list_Length(pairs); i++) {
			cadeia pair = list_GetAt(pairs, i)
			
			inteiro cols[2]
			string_ToVector2Int(pair, cols)

			real boundsA[4]
			real boundsB[4]
			collider_GetUnsolvedBounds(cols[X], boundsA)
			collider_GetUnsolvedBounds(cols[Y], boundsB)

			se (bounds_Touchs(boundsA, boundsB) ou bounds_Intersects(boundsA, boundsB)) {
				list_Add(onCollision, pair)
			}
		}
		retorne onCollision
	}

	funcao cadeia collisionsManager_getPairsToResolve(cadeia pairs) {
		cadeia toResolve = list_New("=")
		para (inteiro i = 0; i < list_Length(pairs); i++) {
			cadeia pair = list_GetAt(pairs, i)
			
			inteiro cols[2]
			string_ToVector2Int(pair, cols)

			real boundsA[4]
			real boundsB[4]
			collider_GetUnsolvedBounds(cols[X], boundsA)
			collider_GetUnsolvedBounds(cols[Y], boundsB)

			se (nao collider_IsTrigger(cols[X]) e nao collider_IsTrigger(cols[Y])) {
				se (bounds_Intersects(boundsA, boundsB)) {
					list_Add(toResolve, pair)
				}
			}
		}
		retorne toResolve
	}

	funcao collisionsManager_resolvePairs(cadeia pairs) {
		para (inteiro i = 0; i < list_Length(pairs); i++) {
			collisionsManager_resolvePair(list_GetAt(pairs, i))
		}
	}

	funcao collisionsManager_resolvePair(cadeia pair) {
		inteiro cols[2]
		string_ToVector2Int(pair, cols)

		inteiro collisionAxis = collisionsManager_getCollisionAxis(cols[X], cols[Y])

		collisionsManager_resolveCollisionAxis(cols[X], cols[Y], collisionAxis)
	}

	funcao inteiro collisionsManager_getCollisionAxis(inteiro colA, inteiro colB) {
		real boundsA[4]
	     real boundsB[4]
	     collider_GetUnsolvedBounds(colA, boundsA)
	     collider_GetUnsolvedBounds(colB, boundsB)
	
	     real distanceX = float_Min(boundsA[RIGHT], boundsB[RIGHT]) - float_Max(boundsA[LEFT], boundsB[LEFT])
	     real distanceY = float_Min(boundsA[UP], boundsB[UP]) - float_Max(boundsA[DOWN], boundsB[DOWN])

          se (distanceX < distanceY) {
          	retorne X
          }
          retorne Y
	}

	funcao collisionsManager_resolveCollisionAxis(inteiro colA, inteiro colB, inteiro axis) {
		real positiveNewDis[] = {0.0, 0.0}
		real negativeNewDis[] = {0.0, 0.0}
		inteiro positiveAxisDir = GetAxisPositiveDirection(axis)
		inteiro negativeAxisDir = GetAxisNegativeDirection(axis)

		//Calcula quem é o colisor negativo e quem é o positivo
		real aPos[2]
		real bPos[2]
		collider_GetAbsolutePosition(colA, aPos)
		collider_GetAbsolutePosition(colB, bPos)

		inteiro positiveCol
		inteiro negativeCol
		
		se (aPos[axis] > bPos[axis]) {
			positiveCol = colA
			negativeCol = colB
		} senao {
			positiveCol = colB
			negativeCol = colA
		}
		//Calcula quem é o colisor negativo e quem é o positivo
		
		//Calcula o deslocamento de correção de cada colisor
		real positiveDis[2]
		real negativeDis[2]
		entity_GetDisplacement(collider_GetEntity(positiveCol), positiveDis)
		entity_GetDisplacement(collider_GetEntity(negativeCol), negativeDis)

		inteiro positiveDisDir[2]
		inteiro negativeDisDir[2]
		vector2_ToDirection(positiveDis, positiveDisDir)	
		vector2_ToDirection(negativeDis, negativeDisDir)

		real positiveBounds[4]
		real negativeBounds[4]
		collider_GetUnsolvedBounds(positiveCol, positiveBounds)
		collider_GetUnsolvedBounds(negativeCol, negativeBounds)

		real overlap = negativeBounds[positiveAxisDir] - positiveBounds[negativeAxisDir]
		se (negativeDisDir[axis] != 0 e positiveDisDir[axis] != 0) {
			real totalDis = negativeDis[axis] - positiveDis[axis]

			positiveNewDis[axis] = -positiveDis[axis] / totalDis * overlap
			negativeNewDis[axis] = -negativeDis[axis] / totalDis * overlap
		} senao se (negativeDisDir[axis] + positiveDisDir[axis] > 0) {
			negativeNewDis[axis] = positiveDis[axis] - negativeDis[axis]
		} senao se (negativeDisDir[axis] + positiveDisDir[axis] < 0) {
			positiveNewDis[axis] = negativeDis[axis] - positiveDis[axis]
		}
		//Calcula o deslocamento de correção de cada colisor

		collider_addDisplacement(positiveCol, positiveNewDis)
		collider_addDisplacement(negativeCol, negativeNewDis)
	}

	funcao collisionsManager_invokeEvents() {
		list_Clear(collisionsManager_enterCollisions)
  		list_Clear(collisionsManager_exitCollisions)
  		
  		para (inteiro i = 0; i < list_Length(collisionsManager_frameCollisions); i++) {
  			cadeia colCode = list_GetAt(collisionsManager_frameCollisions, i)
  			se (nao list_Contains(collisionsManager_lastFrameCollisions, colCode)) {
  				list_Add(collisionsManager_enterCollisions, colCode)
  			}
  		}

  		para (inteiro i = 0; i < list_Length(collisionsManager_lastFrameCollisions); i++) {
  			cadeia colCode = list_GetAt(collisionsManager_lastFrameCollisions, i)
  			se (nao list_Contains(collisionsManager_frameCollisions, colCode)) {
  				list_Add(collisionsManager_exitCollisions, colCode)
  			}
  		}
  		
		para (inteiro i = 0; i < list_Length(collisionsManager_frameCollisions); i++) {
			inteiro cols[2]
			string_ToVector2Int(
				list_GetAt(collisionsManager_frameCollisions, i), 
				cols
			)

			lifecycle_onCollisionStay(cols[X], cols[Y])
		}

		para (inteiro i = 0; i < list_Length(collisionsManager_enterCollisions); i++) {
			inteiro cols[2]
			string_ToVector2Int(
				list_GetAt(collisionsManager_enterCollisions, i), 
				cols
			)

			lifecycle_onCollisionEnter(cols[X], cols[Y])
		}

		para (inteiro i = 0; i < list_Length(collisionsManager_exitCollisions); i++) {
			inteiro cols[2]
			string_ToVector2Int(
				list_GetAt(collisionsManager_exitCollisions, i), 
				cols
			)

			lifecycle_onCollisionExit(cols[X], cols[Y])
		}
	}
	//==================== COLLISIONS MANAGER ====================
	
	//==================== COLLIDER ====================
	const inteiro COLLIDER_TYPE = 2
	const inteiro COLLIDER_FIELDS_COUNT = 7

	const inteiro COLLIDER_IS_ACTIVE = 0
	const inteiro COLLIDER_ENTITY = 1
	const inteiro COLLIDER_IS_TRIGGER = 2
  	const inteiro COLLIDER_SIZE = 3
  	const inteiro COLLIDER_OFFSET = 4
  	const inteiro COLLIDER_DISPLACEMENT = 5
  	const inteiro COLLIDER_SHOULD_SHOW_BOUNDS = 6

	funcao cadeia collider_getField(inteiro reference, inteiro field) {
		retorne objects_GetField(COLLIDER_TYPE, reference, field)
	}

	funcao collider_setField(inteiro reference, inteiro field, cadeia value) {
		objects_SetField(COLLIDER_TYPE, reference, field, value)
	}
	
	funcao inteiro collider_Instantiate(inteiro entity, logico isTrigger, real size[], real offset[], logico showCollider) {
		inteiro reference = objects_NewInstance(COLLIDER_TYPE, COLLIDER_FIELDS_COUNT)
		
		real displacement[] = {0.0, 0.0}

		collider_SetActive(reference, verdadeiro)
		collider_SetEntity(reference, entity)
		collider_SetTrigger(reference, isTrigger)
		collider_SetSize(reference, size)
		collider_SetOffset(reference, offset)
		collider_setDisplacement(reference, displacement)
		collider_SetShouldShowBounds(reference, showCollider)

		retorne reference
	}

	funcao collider_Dispose(inteiro reference) {
		entity_SetCollider(collider_GetEntity(reference), OBJECTS_NULL_INSTANCE)
		objects_Dispose(COLLIDER_TYPE, reference)
	}

	funcao logico collider_IsActive(inteiro reference) {
		retorne string_ToBool(collider_getField(reference, COLLIDER_IS_ACTIVE))
	}

	funcao collider_SetActive(inteiro reference, logico value) {
		collider_setField(
			reference, 
			COLLIDER_IS_ACTIVE, 
			bool_ToString(value)
		)
	}

	funcao inteiro collider_GetEntity(inteiro reference) {
		cadeia stringEntity = collider_getField(reference, COLLIDER_ENTITY)
		retorne string_ToInt(stringEntity)
	}

	funcao collider_SetEntity(inteiro reference, inteiro value) {
		collider_setField(
			reference, 
			COLLIDER_ENTITY, 
			int_ToString(value)
		)
		entity_SetCollider(value, reference)
	}

	funcao logico collider_IsTrigger(inteiro reference) {
		retorne string_ToBool(collider_getField(reference, COLLIDER_IS_TRIGGER))
	}

	funcao collider_SetTrigger(inteiro reference, logico value) {
		collider_setField(
			reference, 
			COLLIDER_IS_TRIGGER, 
			bool_ToString(value)
		)
	}

	funcao collider_GetSize(inteiro reference, real &out[]) {
		cadeia stringPosition = collider_getField(reference, COLLIDER_SIZE)
		string_ToVector2(stringPosition, out)
	}

	funcao collider_SetSize(inteiro reference, real value[]) {
		cadeia stringValue = vector2_ToString(value)
		collider_setField(reference, COLLIDER_SIZE, stringValue)
	}

	funcao collider_GetOffset(inteiro reference, real &out[]) {
		cadeia stringPosition = collider_getField(reference, COLLIDER_OFFSET)
		string_ToVector2(stringPosition, out)
	}

	funcao collider_SetOffset(inteiro reference, real value[]) {
		cadeia stringValue = vector2_ToString(value)
		collider_setField(reference, COLLIDER_OFFSET, stringValue)
	}

	funcao collider_getDisplacement(inteiro reference, real &out[]) {
		cadeia stringPosition = collider_getField(reference, COLLIDER_DISPLACEMENT)
		string_ToVector2(stringPosition, out)
	}

	funcao collider_setDisplacement(inteiro reference, real value[]) {
		cadeia stringValue = vector2_ToString(value)
		collider_setField(reference, COLLIDER_DISPLACEMENT, stringValue)
	}

	funcao logico collider_ShouldShowBounds(inteiro reference) {
		retorne string_ToBool(collider_getField(reference, COLLIDER_SHOULD_SHOW_BOUNDS))
	}

	funcao collider_SetShouldShowBounds(inteiro reference, logico value) {
		collider_setField(
			reference, 
			COLLIDER_SHOULD_SHOW_BOUNDS, 
			bool_ToString(value)
		)
	}

	funcao collider_addDisplacement(inteiro reference, real value[]) {
		real curDis[2]
		collider_getDisplacement(reference, curDis)

		real newDis[] = {
			curDis[X] + value[X],
			curDis[Y] + value[Y]
		}

		collider_setDisplacement(reference, newDis)
	}

	funcao collider_clearDisplacement(inteiro reference) {
		real newDis[] = {0.0, 0.0}
		collider_setDisplacement(reference, newDis)
	}

	funcao collider_GetAbsolutePosition(inteiro reference, real &out[]) {
		real entPos[2]
		real offset[2]
		entity_GetPosition(collider_GetEntity(reference), entPos)
		collider_GetOffset(reference, offset)

		out[X] = entPos[X] + offset[X]
		out[Y] = entPos[Y] + offset[Y]
	}

	funcao collider_GetUnsolvedAbsolutePosition(inteiro reference, real &out[]) {
		real absPos[2]
		real entityDis[2]
		real colliderDis[2]
		
		collider_GetAbsolutePosition(reference, absPos)
		entity_GetDisplacement(collider_GetEntity(reference), entityDis)
		collider_getDisplacement(reference, colliderDis)
		
		out[X] = absPos[X] + entityDis[X] + colliderDis[X]
		out[Y] = absPos[Y] + entityDis[Y] + colliderDis[Y]
	}

	funcao collider_GetBounds(inteiro reference, real &out[]) {
		real pos[2]
		real size[2]
		collider_GetAbsolutePosition(reference, pos)
		collider_GetSize(reference, size)

		out[LEFT] = pos[X]
		out[RIGHT] = pos[X] + size[X]
		out[DOWN] = pos[Y]
		out[UP] = pos[Y] + size[Y]
	}

	funcao collider_GetUnsolvedBounds(inteiro reference, real &out[]) {
		real pos[2]
		real size[2]
		collider_GetUnsolvedAbsolutePosition(reference, pos)
		collider_GetSize(reference, size)

		out[LEFT] = pos[X]
		out[RIGHT] = pos[X] + size[X]
		out[DOWN] = pos[Y]
		out[UP] = pos[Y] + size[Y]
	}
	//==================== COLLIDER ====================

	//==================== UTILS ====================
	funcao inteiro GetArrayLength_string(cadeia array[]) {
  		retorne utils.numero_elementos(array)
  	}

  	funcao inteiro GetArrayLength_int(inteiro array[]) {
  		retorne utils.numero_elementos(array)
  	}

  	funcao inteiro GetArrayLength_float(real array[]) {
  		retorne utils.numero_elementos(array)
  	}

  	funcao ClearArray_string(cadeia &array[]) {
  		para (inteiro i = 0; i < GetArrayLength_string(array); i++) {
  			array[i] = ""
  		}
  	}

  	funcao PauseExecution() {
  		cadeia a
		leia(a)
  	}

  	funcao inteiro ThrowException(cadeia mesage) {
  		escreva(mesage)
  		inteiro a[] = {1}
  		retorne a[1]
  	}

	funcao cadeia string_Substring(cadeia string, inteiro startI, inteiro endI) {
		retorne text.extrair_subtexto(string, startI, endI + 1)
	}
	
  	funcao inteiro string_Length(cadeia string) {
  		retorne text.numero_caracteres(string)
  	}

  	funcao cadeia string_GetChar(cadeia string, inteiro index) {
  		retorne 
  			types.caracter_para_cadeia(
	  			text.obter_caracter(
	  				string, index)
	  		)
  	}

  	funcao real float_Round(real num) {
  		retorne math.arredondar(num, 0)
  	}

  	funcao inteiro float_RoundToInt(real num) {
  		retorne float_ToInt(float_Round(num))
  	}

  	funcao real float_Max(real a, real b) {
  		se (a > b) {
  			retorne a
  		}
  		retorne b
  	}

  	funcao real float_Min(real a, real b) {
  		se (a < b) {
  			retorne a
  		}
  		retorne b
  	}

  	funcao real vector2_Magnitude(real vector[]) {
		retorne math.raiz(
	     	vector[X] * vector[X] +
	     	vector[Y] * vector[Y],
	     	2.0
		)
	}

	funcao vector2_Normalize(real &vector[]) {
		real magnitude = vector2_Magnitude(vector)

     	se (magnitude == 0.0) {
     		retorne
    		}

    		vector[X] = vector[X] / magnitude
    		vector[Y] = vector[Y] / magnitude
	}

  	funcao vector2_ToDirection(real vector2[], inteiro &out[]) {
  		se (vector2[X] > 0) {
  			out[X] = 1
  		} senao se (vector2[X] < 0) {
  			out[X] = -1
  		} senao {
  			out[X] = 0
  		}

  		se (vector2[Y] > 0) {
  			out[Y] = 1
  		} senao se (vector2[Y] < 0) {
  			out[Y] = -1
  		} senao {
  			out[Y] = 0
  		}
  	}

  	funcao vector2Int_SortAscending(inteiro &vector[]) {
  		inteiro x = vector[X]
  		inteiro y = vector[Y]
  		se (x > y) {
  			vector[X] = y
  			vector[Y] = x
  		}
  	}

  	funcao logico bounds_Intersects(real bundsA[], real boundsB[]) {
  		retorne
	        bundsA[LEFT] < boundsB[RIGHT] e
	        bundsA[RIGHT] > boundsB[LEFT] e
	        bundsA[UP] > boundsB[DOWN] e
	        bundsA[DOWN] < boundsB[UP]
  	}

  	funcao logico bounds_Touchs(real boundsA[], real boundsB[]) {
  		retorne
		     (
		          boundsA[RIGHT] == boundsB[LEFT] e
		          boundsA[DOWN] < boundsB[UP] e
		          boundsA[UP] > boundsB[DOWN]
		     ) ou
		     (
			     boundsA[LEFT] == boundsB[RIGHT] e
			     boundsA[DOWN] < boundsB[UP] e
			     boundsA[UP] > boundsB[DOWN]
		     ) ou
		     (
			     boundsA[DOWN] == boundsB[UP] e
			     boundsA[RIGHT] > boundsB[LEFT] e
			     boundsA[LEFT] < boundsB[RIGHT]
		     ) ou
		     (
			     boundsA[UP] == boundsB[DOWN] e
			     boundsA[RIGHT] > boundsB[LEFT] e
			     boundsA[LEFT] < boundsB[RIGHT]
		     )
  	}

  	funcao inteiro GetAxisPositiveDirection(inteiro axis) {
  		se (axis == X) {
  			retorne RIGHT
  		}
  		retorne UP
  	}

  	funcao inteiro GetAxisNegativeDirection(inteiro axis) {
  		se (axis == X) {
  			retorne LEFT
  		}
  		retorne DOWN
  	}
	//==================== UTILS ====================

	//==================== CONVERSION ====================
	const cadeia STRUCT_SEPARATOR = "_"
	const inteiro VECTOR2_LENGTH = 2
	const inteiro BOUNDS_LENGTH = 4

	funcao inteiro string_ToInt(cadeia string) {
  		retorne types.cadeia_para_inteiro(string, 10)
  	}

  	funcao real string_ToFloat(cadeia string) {
  		retorne types.cadeia_para_real(string)
  	}

  	funcao logico string_ToBool(cadeia string) {
  		retorne types.cadeia_para_logico(string)
  	}

  	funcao string_ToArrayString(cadeia string, cadeia &out[], cadeia separator) {
  		ClearArray_string(out)
  		inteiro currentItem = 0

  		para (inteiro i = 0; i < string_Length(string); i++) {
  			cadeia char = string_GetChar(string, i)
  			
	  		se (char == SEPARATOR e string_GetChar(string, i + 1) == separator) {
	  			currentItem++
	  			i++
	  		}
	  		senao {
	  			out[currentItem] += char
	  		}
  		}
  	}

  	funcao string_ToVector2(cadeia string, real &out[]) {
  		cadeia stringVector[VECTOR2_LENGTH]
  		string_ToArrayString(string, stringVector, STRUCT_SEPARATOR)
  		arrayString_ToArrayFloat(stringVector, out)
  	}

  	funcao string_ToVector2Int(cadeia string, inteiro &out[]) {
  		cadeia stringVector[VECTOR2_LENGTH]
  		string_ToArrayString(string, stringVector, STRUCT_SEPARATOR)
  		arrayString_ToArrayInt(stringVector, out)
  	}

  	funcao string_ToBounds(cadeia string, inteiro &out[]) {
  		cadeia stringVector[BOUNDS_LENGTH]
  		string_ToArrayString(string, stringVector, STRUCT_SEPARATOR)
  		arrayString_ToArrayInt(stringVector, out)
  	}

  	funcao cadeia arrayString_ToString(cadeia array[], cadeia separator) {
  		cadeia stringArray = ""
		inteiro length = GetArrayLength_string(array)
		
		para (inteiro i = 0; i < length; i++) {
			stringArray += array[i]
			se (i != length - 1) {
				stringArray += SEPARATOR + separator
			}
		}
		
		retorne stringArray
  	}

  	funcao arrayString_ToArrayInt(cadeia stringArray[], inteiro &out[]) {
	    para (inteiro i = 0; i < GetArrayLength_string(stringArray); i++) {
	        out[i] = string_ToInt(stringArray[i])
	    }
	}

	funcao arrayString_ToArrayFloat(cadeia stringArray[], real &out[]) {
	    para (inteiro i = 0; i < GetArrayLength_string(stringArray); i++) {
	        out[i] = string_ToFloat(stringArray[i])
	    }
	}

  	funcao cadeia int_ToString(inteiro int) {
  		retorne types.inteiro_para_cadeia(int, 10)
  	}

  	funcao real int_ToFloat(inteiro int) {
		retorne types.inteiro_para_real(int)
	}

	funcao arrayInt_ToArrayString(inteiro intArray[], cadeia &out[]) {
  		para (inteiro i = 0; i < GetArrayLength_int(intArray); i++) {
  			out[i] = int_ToString(intArray[i])
  		}
  	}

  	funcao cadeia float_ToString(real float) {
  		retorne types.real_para_cadeia(float)
  	}
	
	funcao inteiro float_ToInt(real float) {
		retorne types.real_para_inteiro(float)
	}

	funcao arrayFloat_ToArrayString(real floatArray[], cadeia &out[]) {
  		para (inteiro i = 0; i < GetArrayLength_float(floatArray); i++) {
  			out[i] = float_ToString(floatArray[i])
  		}
  	}

  	funcao cadeia bool_ToString(logico bool) {
  		retorne types.logico_para_cadeia(bool)
  	}
  	
	funcao cadeia vector2_ToString(real vector2[]) {
  		cadeia stringVector[VECTOR2_LENGTH]
  		arrayFloat_ToArrayString(vector2, stringVector)
  		retorne arrayString_ToString(stringVector, STRUCT_SEPARATOR)
  	}
  	
	funcao vector2_ToVector2Int(real vector2[], inteiro &out[]) {
  		out[X] = float_ToInt(vector2[X])
  		out[Y] = float_ToInt(vector2[Y])
  	}
	
	funcao cadeia vector2Int_ToString(inteiro vector2[]) {
  		cadeia stringVector[VECTOR2_LENGTH]
  		arrayInt_ToArrayString(vector2, stringVector)
  		retorne arrayString_ToString(stringVector, STRUCT_SEPARATOR)
  	}
	
	funcao Vector2IntToVector2(inteiro vector2[], real &out[]) {
  		out[X] = int_ToFloat(vector2[X])
  		out[Y] = int_ToFloat(vector2[Y])
  	}
	
	funcao cadeia bounds_ToString(inteiro vector2[]) {
  		cadeia stringVector[BOUNDS_LENGTH]
  		arrayInt_ToArrayString(vector2, stringVector)
  		retorne arrayString_ToString(stringVector, STRUCT_SEPARATOR)
  	}

  	funcao direction_ToVector2Int(inteiro direction, inteiro &out[]) {
  		se (direction == LEFT) {
  			out[X] = -1
  			out[Y] = 0
  		}
  		se (direction == RIGHT) {
  			out[X] = 1
  			out[Y] = 0
  		}
  		se (direction == UP) {
  			out[X] = 0
  			out[Y] = 1
  		}
  		se (direction == DOWN) {
  			out[X] = 0
  			out[Y] = -1
  		}
  	}
	//==================== CONVERSION ====================

	//==================== LIST ====================
	const inteiro LIST_NOT_FOUND_ITEM = -1
	
	funcao cadeia list_New(cadeia separator) {
		cadeia stringArray = separator
		retorne stringArray
	}
	
	funcao cadeia list_FromArray(cadeia array[], cadeia separator) {
		cadeia stringArray = separator
		inteiro length = GetArrayLength_string(array)
		
		para (inteiro i = 0; i < length; i++) {
			stringArray += array[i]
			se (i != length - 1) {
				stringArray += SEPARATOR + separator
			}
		}
		
		retorne stringArray
	}

	funcao list_Add(cadeia &list, cadeia item) {
		cadeia separator = string_GetChar(list, 0)
		
		se (list != separator) {
			list += SEPARATOR + separator
		}
		list += item 
	}

	funcao list_InsertBefore(cadeia &list, inteiro index, cadeia item) {
		cadeia separator = string_GetChar(list, 0)
		inteiro length = list_Length(list)
		
		se (index == 0) {
			list = separator + item + SEPARATOR + list
			retorne
		}

		se (index >= length) {
			ThrowException("Tentaiva de inserir item antes de um indice fora dos limites da lista")
		}
		
		cadeia interval1 = list_GetInterval(list, 0, index - 1)
		cadeia interval2 = list_GetInterval(list, index, length - 1)
		interval2 = string_Substring(interval2, 1, string_Length(interval2) - 1)
		
		list = 
			interval1 + 
			SEPARATOR + 
			separator + 
			item + 
			SEPARATOR + 
			separator + 
			interval2
	}

	funcao list_InsertAfter(cadeia &list, inteiro index, cadeia item) {
		se (index == list_Length(list) - 1) {
			list_Add(list, item)
			retorne
		}

		list_InsertBefore(list, index + 1, item)
	}

	funcao list_RemoveAt(cadeia &list, inteiro index) {
		se (list_Length(list) == 1 e index == 0) {
			list_Clear(list)
			retorne
		}
		
		inteiro startSectionStart = 0
		inteiro startSectionEnd = list_getIndexStart(list, index) - 1
		
		inteiro endSectionStart = list_getIndexFinal(list, index) + 3
		inteiro endSectionEnd = string_Length(list) - 1

		se (endSectionStart > endSectionEnd) {
			endSectionStart -= 2
			startSectionEnd -= 2
		}
		
		cadeia startSection = string_Substring(
			list, 
			startSectionStart, 
			startSectionEnd
		)

		cadeia endSection = string_Substring(
			list, 
			endSectionStart, 
			endSectionEnd
		)

		list = startSection + endSection
	}

	funcao list_RemoveFirst(cadeia &list, cadeia item) {
		inteiro first = list_GetFirst(list, item)
		se (first != LIST_NOT_FOUND_ITEM) {
			list_RemoveAt(list, first)
		}
	}

	funcao list_Clear(cadeia &list) {
		list = string_GetChar(list, 0)
	}

	funcao cadeia list_GetAt(cadeia list, inteiro index) {
		retorne string_Substring(
			list, 
			list_getIndexStart(list, index), 
			list_getIndexFinal(list, index)
		)
	}

	funcao cadeia list_GetInterval(cadeia list, inteiro startIndex, inteiro finalIndex) {
		cadeia newList = list_New(string_GetChar(list, 0))
		para (inteiro i = startIndex; i <= finalIndex; i++) {
			list_Add(newList, list_GetAt(list, i))
		}
		retorne newList
	}

	funcao inteiro list_GetFirst(cadeia list, cadeia item) {
		para (inteiro i = 0; i < list_Length(list); i++) {
			se (list_GetAt(list, i) == item) {
				retorne i
			}
		}
		retorne LIST_NOT_FOUND_ITEM
	}

	funcao logico list_Contains(cadeia list, cadeia item) {
		inteiro first = list_GetFirst(list, item)
		retorne first != LIST_NOT_FOUND_ITEM
	}

	funcao list_Set(cadeia &list, inteiro index, cadeia value) {
		cadeia startSection = string_Substring(
			list, 
			0, 
			list_getIndexStart(list, index) - 1
		)

		cadeia endSection = string_Substring(
			list, 
			list_getIndexFinal(list, index) + 1, 
			string_Length(list) - 1
		)

		list = startSection + value + endSection
	}

	funcao inteiro list_getIndexFinal(cadeia list, inteiro index) {
		inteiro length = list_Length(list)
		inteiro itemLastIndex = string_Length(list) - 1
		
		se (index != length - 1) {
			itemLastIndex = list_getIndexStart(list, index + 1) - 3
		}

		retorne itemLastIndex
	}

	funcao inteiro list_getIndexStart(cadeia list, inteiro index) {
		se (index == 0) {
    			retorne 1
		}
		cadeia separator = string_GetChar(list, 0)
		
		inteiro currentItem = 0
		para (inteiro i = 0; i < string_Length(list); i++) {
			cadeia char = string_GetChar(list, i)	
			
			se (char == SEPARATOR) {
				se (string_GetChar(list, i + 1) == separator) {
					currentItem++
					i++
				}
			}

			se (currentItem == index) {
				retorne i + 1
			}
		}
		
		retorne ThrowException("Index fora dos limites do array")
	}

	funcao inteiro list_Length(cadeia list) {
		cadeia separator = string_GetChar(list, 0)
		se (list == separator) {
			retorne 0
		}
		
		inteiro length = 1
		para (inteiro i = 0; i < string_Length(list); i++) {
			cadeia char = string_GetChar(list, i)	
			
			se (char == SEPARATOR) {
				se (string_GetChar(list, i + 1) == separator) {
					length++
					i++
				}
			}
		}
		retorne length
	}

	funcao list_Sort(cadeia &list) {
		cadeia sortedList = list_New(string_GetChar(list, 0))
		
		inteiro firstItem = string_ToInt(list_GetAt(list, 0))
		list_Add(sortedList, int_ToString(firstItem))
		
		para (inteiro i = 1; i < list_Length(list); i++) {
			inteiro item = string_ToInt(list_GetAt(list, i))
			inteiro sortedLength = list_Length(sortedList)
			
			para (inteiro k = 0; k < sortedLength; k++) {
				se (string_ToInt(list_GetAt(sortedList, k)) > item) {
					list_InsertBefore(
						sortedList, 
						k, 
						int_ToString(item)
					)
					k = sortedLength
				} senao se (k == sortedLength - 1) {
					list_Add(sortedList, int_ToString(item))
				}
			}
		}

		list = sortedList
	}
	//==================== LIST ====================
	
	//==================== LIFECYCLE ====================
	funcao lifecycle_start() {
		gameStart()
	}

	funcao lifecycle_update() {
		gameUpdate()

		escreva("\n", time_avarageFps)
	}

	funcao lifecycle_onKeyDown(inteiro key) {
	}

	funcao lifecycle_onKeyUp(inteiro key) {
	}

	funcao lifecycle_onCollisionEnter(inteiro colA, inteiro colB) {
	}

	funcao lifecycle_onCollisionExit(inteiro colA, inteiro colB) {
	}

	funcao lifecycle_onCollisionStay(inteiro colA, inteiro colB) {
	}
	//==================== LIFECYCLE ====================

	//==================== GAME ====================
	inteiro player1 = 0
	inteiro player2 = 0
	
	funcao gameStart() {
		setBackground()

		cadeia keys1[4]
		getPlayerKeys1(keys1)
		player1 = instantiatePlayer(
			"image.jpg", 
			1, 
			200.0,
			0.0,
			0.0,
			300.0, 
			200.0, 
			keys1
		)

		cadeia keys2[4]
		getPlayerKeys2(keys2)
		player2 = instantiatePlayer(
			"image.jpg", 
			1, 
			200.0,
			500.0,
			0.0,
			300.0, 
			200.0, 
			keys2
		)
	}

	funcao gameUpdate() {
		player_Update(player1)
		player_Update(player2)
	}

	funcao setBackground() {
		real position[] = {0.0, 0.0}
		cadeia image = DIRECTORY + "background.jpg"
		real size[] = {
			int_ToFloat(WINDOW_SIZE[X]),
			int_ToFloat(WINDOW_SIZE[Y])
		}
		
		inteiro entity = entity_Instantiate(position)
		renderer_Instantiate(entity, image, size, 0)
	}

	funcao inteiro instantiatePlayer(
		cadeia image, 
		inteiro layer, 
		real speed, 
		real startX,
		real startY,
		real sizeX, 
		real sizeY, 
		cadeia keys[]
	) {
		real position[] = {startX, startY}
		inteiro entity = entity_Instantiate(position)	
		
		cadeia imagePath = DIRECTORY + image
		real size[] = {sizeX, sizeY}
		renderer_Instantiate(entity, imagePath, size, 1)
				
		real offSet[] = {0.0, 0.0}
		collider_Instantiate(entity, falso, size, offSet, falso)

		retorne player_Instantiate(entity, speed, keys)
	}

	funcao getPlayerKeys1(cadeia &out[]) {
		inteiro keyA[] = { k.TECLA_A, LEFT }
		inteiro keyD[] = { k.TECLA_D, RIGHT }
		inteiro keyW[] = { k.TECLA_W, UP }
		inteiro keyS[] = { k.TECLA_S, DOWN }

		out[0] = vector2Int_ToString(keyA)
		out[1] = vector2Int_ToString(keyD)
		out[2] = vector2Int_ToString(keyW)
		out[3] = vector2Int_ToString(keyS)
	}

	funcao getPlayerKeys2(cadeia &out[]) {
		inteiro keyA[] = { k.TECLA_SETA_ESQUERDA, LEFT }
		inteiro keyD[] = { k.TECLA_SETA_DIREITA, RIGHT }
		inteiro keyW[] = { k.TECLA_SETA_ACIMA, UP }
		inteiro keyS[] = { k.TECLA_SETA_ABAIXO, DOWN }

		out[0] = vector2Int_ToString(keyA)
		out[1] = vector2Int_ToString(keyD)
		out[2] = vector2Int_ToString(keyW)
		out[3] = vector2Int_ToString(keyS)
	}
	//==================== GAME ====================

	//==================== PLAYER ====================
	const inteiro PLAYER_TYPE = 3
	const inteiro PLAYER_FIELDS_COUNT = 4

	const inteiro PLAYER_IS_ACTIVE = 0
  	const inteiro PLAYER_ENTITY = 1
  	const inteiro PLAYER_SPEED = 2
  	const inteiro PLAYER_KEYS = 3
  	
	funcao cadeia player_getField(inteiro reference, inteiro field) {
		retorne objects_GetField(PLAYER_TYPE, reference, field)
	}

	funcao player_setField(inteiro reference, inteiro field, cadeia value) {
		objects_SetField(PLAYER_TYPE, reference, field, value)
	}
	
	funcao inteiro player_Instantiate(inteiro entity, real speed, cadeia keys[]) {
		inteiro reference = objects_NewInstance(PLAYER_TYPE, PLAYER_FIELDS_COUNT)

		player_SetActive(reference, verdadeiro)
		player_SetEntity(reference, entity)
		player_SetSpeed(reference, speed)
		player_setKeys(reference, keys)

		retorne reference
	}

	funcao player_Dispose(inteiro reference) {
		objects_Dispose(PLAYER_TYPE, reference)
	}

	funcao logico player_IsActive(inteiro reference) {
		retorne string_ToBool(player_getField(reference, PLAYER_IS_ACTIVE))
	}

	funcao player_SetActive(inteiro reference, logico value) {
		player_setField(
			reference, 
			PLAYER_IS_ACTIVE, 
			bool_ToString(value)
		)
	}

	funcao inteiro player_GetEntity(inteiro reference) {
		cadeia stringEntity = player_getField(reference, PLAYER_ENTITY)
		retorne string_ToInt(stringEntity)
	}

	funcao player_SetEntity(inteiro reference, inteiro newEntity) {
		player_setField(
			reference, 
			PLAYER_ENTITY, 
			int_ToString(newEntity)
		)
	}

	funcao real player_GetSpeed(inteiro reference) {
		cadeia stringSpeed = player_getField(reference, PLAYER_SPEED)
		retorne string_ToFloat(stringSpeed)
	}

	funcao player_SetSpeed(inteiro reference, real value) {
		player_setField(
			reference, 
			PLAYER_SPEED, 
			float_ToString(value)
		)
	}

	funcao player_GetKeys(inteiro reference, cadeia &out[]) {
		string_ToArrayString(
			player_getField(reference, PLAYER_KEYS), 
			out, 
			"="
		)
	}

	funcao player_setKeys(inteiro reference, cadeia keys[]) {
		player_setField(
			reference, 
			PLAYER_KEYS, 
			arrayString_ToString(keys, "=")
		)
	}

	funcao player_Update(inteiro reference) {
		inteiro entity = player_GetEntity(reference)
		real speed = player_GetSpeed(reference)
		real direction[2]
		player_GetMoveDirection(reference, direction)
		
		direction[X] *= speed * time_deltaTime
		direction[Y] *= speed * time_deltaTime
		
		
		entity_Move(entity, direction)
	}

	funcao player_GetMoveDirection(inteiro reference, real &out[]) {
		out[X] = 0.0
		out[Y] = 0.0
		
		cadeia keys[4]
		player_GetKeys(reference, keys)

		para (inteiro i = 0; i < GetArrayLength_string(keys); i++) {
			inteiro pair[2]
			string_ToVector2Int(keys[i], pair)

			se (input_IsKeyDown(pair[X])) {
				inteiro keyDirection[2]
				direction_ToVector2Int(pair[Y], keyDirection)

				out[X] += keyDirection[X]
				out[Y] += keyDirection[Y]
			}
		}

		vector2_Normalize(out)
	}
	//==================== PLAYER ====================
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 529; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = vetor, matriz, funcao;
 */