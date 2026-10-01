Feature: API de Usuarios en ServeRest
  Como administrador del sistema
  Quiero gestionar los usuarios a través de la API
  Para administrar la base de datos de usuarios

  Background:
    * url baseUrl
    * def DataGenerator = Java.type('serverest.helpers.DataGenerator')
    * def userSchema =
    """
    {
      nome: '#string',
      email: '#string',
      password: '#string',
      administrador: '#string',
      _id: '#string'
    }
    """
    * def successResponseSchema =
    """
    {
      message: '#string',
      _id: '##string'
    }
    """
    * def errorResponseSchema =
    """
    {
      message: '#string'
    }
    """

  Scenario: Obtener una lista de todos los usuarios
    Given path '/usuarios'
    When method get
    Then status 200
    And match response.quantidade == '#number'
    And match response.usuarios == '#[] userSchema'

  Scenario: Registrar un nuevo usuario con datos válidos
    * def randomUser = DataGenerator.getRandomUser()
    Given path '/usuarios'
    And request randomUser
    When method post
    Then status 201
    And match response == successResponseSchema
    And match response.message == 'Cadastro realizado com sucesso'
    * def userId = response._id
    
    # teardown
    Given path '/usuarios', userId
    When method delete
    Then status 200

  Scenario: Intentar registrar un usuario sin nombre (Caso Negativo)
    * def badUser = DataGenerator.getRandomUser()
    * remove badUser.nome
    Given path '/usuarios'
    And request badUser
    When method post
    Then status 400
    And match response.nome == 'nome é obrigatório'

  Scenario: Buscar un usuario específico por su ID
    * def randomUser = DataGenerator.getRandomUser()
    Given path '/usuarios'
    And request randomUser
    When method post
    Then status 201
    * def userId = response._id

    Given path '/usuarios', userId
    When method get
    Then status 200
    And match response == userSchema
    And match response.email == randomUser.email

    # teardown
    Given path '/usuarios', userId
    When method delete
    Then status 200

  Scenario: Buscar un usuario inexistente por ID (Caso Negativo)
    Given path '/usuarios', '0000000000000000'
    When method get
    Then status 400
    And match response == errorResponseSchema
    And match response.message == 'Usuário não encontrado'

  Scenario: Actualizar la información de un usuario existente
    * def randomUser = DataGenerator.getRandomUser()
    Given path '/usuarios'
    And request randomUser
    When method post
    Then status 201
    * def userId = response._id

    * def updatedUser = DataGenerator.getRandomUser()
    Given path '/usuarios', userId
    And request updatedUser
    When method put
    Then status 200
    And match response == successResponseSchema
    And match response.message == 'Registro alterado com sucesso'

    Given path '/usuarios', userId
    When method get
    Then status 200
    And match response.email == updatedUser.email

    # teardown
    Given path '/usuarios', userId
    When method delete
    Then status 200

  Scenario: Intentar actualizar usando un email que ya existe (Caso Negativo)
    # Creamos un usuario base
    * def randomUser1 = DataGenerator.getRandomUser()
    Given path '/usuarios'
    And request randomUser1
    When method post
    Then status 201
    * def userId1 = response._id

    # Creamos otro usuario
    * def randomUser2 = DataGenerator.getRandomUser()
    Given path '/usuarios'
    And request randomUser2
    When method post
    Then status 201
    * def userId2 = response._id

    # Intentamos actualizar el usuario 2 con el email del usuario 1
    * def updatedUser = randomUser2
    * set updatedUser.email = randomUser1.email
    Given path '/usuarios', userId2
    And request updatedUser
    When method put
    Then status 400
    And match response == errorResponseSchema
    And match response.message == 'Este email já está sendo usado'

    # teardown
    Given path '/usuarios', userId1
    When method delete
    Then status 200
    Given path '/usuarios', userId2
    When method delete
    Then status 200

  Scenario: Eliminar un usuario del sistema
    * def randomUser = DataGenerator.getRandomUser()
    Given path '/usuarios'
    And request randomUser
    When method post
    Then status 201
    * def userId = response._id

    Given path '/usuarios', userId
    When method delete
    Then status 200
    And match response == successResponseSchema
    And match response.message == 'Registro excluído com sucesso'

    Given path '/usuarios', userId
    When method get
    Then status 400
    And match response == errorResponseSchema
    And match response.message == 'Usuário não encontrado'

  Scenario: Intentar eliminar un usuario inexistente (Caso Negativo)
    Given path '/usuarios', '0000000000000000'
    When method delete
    Then status 200
    And match response == errorResponseSchema
    And match response.message == 'Nenhum registro excluído'
