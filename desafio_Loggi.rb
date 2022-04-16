
# função que verifica se os pacotes possui um codigo invalido
# se possui retorna o codigo do pacote invalido
def invalid (cod_or,cod_ds,cod_lg,cod_sl,cod_pd, id) 
    #invalido por codigo loggi
    unless ((cod_pd == "001")|| (cod_pd == "111") || (cod_pd == "333") || (cod_pd == "555") || (cod_pd == "888"))
        return id
    end
    #invalido tipo: joias  origem: centro oeste
    if ( (cod_or.to_i >= 201) && (cod_or.to_i  <= 299) && (cod_pd == "001") )
        return id
    end
    #invalido vendedor 367 inativo
    if cod_sl == "367"
        return id
    end

    if ( (cod_or == "000") || (cod_or == "200") || (cod_ds== "000") || (cod_ds == "200") ) 
        return id
    end

    return 'n'

end

# Função que ler todos os pacotes, caso detecte um pacote com código inválido
# retira esse pacota da lista de pacotes válidos e insere na lista de pacotes inválidos
def get_invalid(data)
    array = []
    sub = 0
    data.each_with_index do |line, index|
        code = line.split(": ")[1].chomp    #recebe o codigo que vai ser processado    
        origem = code.slice(0..2)
        destino = code.slice(3..5)
        cod_loggi = code.slice(6..8)
        cod_seller = code.slice(9..11)
        cod_type = code.slice(12..15)
        valid = invalid(origem,destino,cod_loggi,cod_seller,cod_type,index)
        unless valid == 'n'
            array.append(valid)
        end    
    end 
    array.each do|id|
        if data.delete_at(id.to_i-sub)
            sub +=1
        end     
    end  

    return array
end    

# Função responsavel por verificar a quatidade de pacotes que vai 
# para cada regiao destino
def count_pedidos (data)  #questao 1
    array = [0,0,0,0,0]
    data.each do |item|
        cod_destino = item.split(": ")[1].chomp.slice(3..5) #pegando so o codigo Loggi
        if (cod_destino.to_i >= 1) && (cod_destino.to_i  <= 99) # sudeste
            array[0] += 1
        elsif (cod_destino.to_i >= 100) && (cod_destino.to_i  <= 199) # sul
            array[1]+= 1
        elsif (cod_destino.to_i >= 201) && (cod_destino.to_i  <= 299) # centro-oeste
            array[2] += 1
        elsif (cod_destino.to_i >= 300) && (cod_destino.to_i  <= 399) # nordeste
            array[3]+= 1
        elsif (cod_destino.to_i >= 400) && (cod_destino.to_i  <= 499) # norte
            array[4] += 1  
        end
    end    
    return array

end

# função responsavel por Identificar os pacotes que têm como origem a região Sul e
# Brinquedos no codigo do pacote
def south_toys (data)
    array = []
    data.each_with_index do |item,id|
        code = item.split(": ")[1].chomp    #recebe o codigo que vai ser processado    
        origem = code.slice(0..2)
        cod_type = code.slice(12..15)
        if ((origem.to_i >= 100) && (origem.to_i  <= 199) &&(cod_type == "888"))
            array.append(data[id])
        end    

    end   
    return array 
end

# Função que listar os pacote de acordo com a região de destino deles
def list_destino (data)  
    sudeste = [];sul = [];centro_oeste = []
    nordeste = [];norte = []
    data.each_with_index do |item,id|
        cod_destino = item.split(": ")[1].chomp.slice(3..5) #pegando so o codigo Loggi
        
        if (cod_destino.to_i > 99) && (cod_destino.to_i  < 200) # sul
            sul.append(data[id])
        elsif ((cod_destino.to_i > 0) && (cod_destino.to_i  < 100)) # sudeste
            sudeste.append(data[id])
        elsif (cod_destino.to_i > 200) && (cod_destino.to_i  < 300) # centro-oeste
            centro_oeste.append(data[id])
        elsif (cod_destino.to_i > 299) && (cod_destino.to_i  < 400) # nordeste
            nordeste.append(data[id])
        elsif (cod_destino.to_i > 399) && (cod_destino.to_i  < 500) # norte
            norte.append(data[id])
        else    
        end
    end  
    return [sudeste,sul,centro_oeste,nordeste,norte]

end
# função que mostar a lista dos pacote de acordo com a região de destino
def get_list_destino(list)
    regioes = ["sudeste", "sul", "centro-oeste", "nordeste", "norte"]
    list.each_with_index do |item,id|
        puts "Pacotes com destino a região #{regioes[id]}: #{item.size}"
        puts item
        puts "\n"
    end 
end  

# função que mostar a lista dos pacote de cada vendedor
def get_list_sellers (data)
    sellers = []
    sellers2 = []
    data.each_with_index do |item,id|
        sellers.append(item.split(": ")[1].chomp.slice(9..11))
    end
  
    sellers = sellers.uniq!     # metodo do ruby para retirar duplicações
    list_sellers = []
    for i in 0..sellers.size
        list = [] 
        data.each_with_index do |item,id|
            aux = item.split(": ")[1].chomp.slice(9..11)
            if aux == sellers[i]
                list.append(item)
            end    
        end 
        list_sellers.append(list)
    end
    
    sellers.each_with_index do |seller,id|
        puts "Pacotes do vendedor #{seller}"
        puts  list_sellers[id]
        print "\n"
    end    
end    

# função que apresenta uma lista de pacotes por destino e por tipo
def get_list_dest_type(data)
    sudeste = list_dest_type(data,0,100)
    sul = list_dest_type(data,99,200)
    centro_oeste = list_dest_type(data,200,300)
    nordeste = list_dest_type(data,299,400)
    norte = list_dest_type(data,399,500)
    regioes = [sudeste , sul, centro_oeste,nordeste, norte]
    regioesName = ["sudeste" , "sul", "centro_oeste","nordeste", "norte"]
    typeName = ["joias","livros","eletrônicos","bebidas","brinquedos"]
    regioes.each_with_index do |item,id|
        puts "Pacotes com Destino a região #{regioesName[id]}"
        item.each_with_index do |type,i|
            puts "Do Tipo #{typeName[i]}"
            if type.size == 0
                puts " Não possui pacotes desse tipo"
            else    
                puts type
            end    
        end 
        puts "\n"    
    end    
end

# função que gera uma lista de pacotes por tipo
def list_dest_type(data,cod_destino1,cod_destino2)
    joias = []
    livros = []
    eletrônicos = []
    bebidas = []
    brinquedos = []
    data.each_with_index do |item,id|
        code_type = item.split(": ")[1].chomp.slice(12..15)
        code_destino = item.split(": ")[1].chomp.slice(3..5)
        if (code_destino.to_i > cod_destino1) && (code_destino.to_i < cod_destino2)
            case code_type
                when "001"          # Jóias
                    joias.append(item)
                when "111"          # Livros
                    livros.append(item)    
                when "333"          # Eletrônicos
                    eletrônicos.append(item)
                when "555"          # Bebidas
                    bebidas.append(item)
                when "888"          # Brinquedos
                    brinquedos.append(item)
                else
            end
        end    
    end
    return [joias,livros,eletrônicos,bebidas,brinquedos]
end


# -------------- Desafio 7 --------------------- 
 
# Supondo que todos os caminhoes partem de um
# centro de distribuição central da sua região 
# antes de partirem para outras regiões

# Obs: Entregas dentro da região norte não iram ser
# consideradas devido ao custo alto que geraria, o
# mesmo vale para entregas de origem da região centro oeste
# vistoe que vão existem caminhoes reponsaveis para a 
# distribuição regional  

# função resposavel por aproveitar entregar no Norte e assim
# realocar encomendas para o Centro Oeste, assim diminuindo
# os custos de operação.
def get_list_to_norte_centro_oeste(data)
    caminhao_sul = []
    caminhao_sudeste = []
    caminhao_nordeste = []
    to_north = []
    to_north_origins= []
    to_north_origins_id =[]
    sul = []
    sudeste = []
    nordeste = []

    
    data.each_with_index do |item,id|
        code_origem = item.split(": ")[1].chomp.slice(0..2)
        code_destino = item.split(": ")[1].chomp.slice(3..5)
        # Lista os pacotes que vão para o norte
        if (code_destino.to_i > 399) && (code_destino.to_i  < 500)
            to_north.append(item)
        end
        # Lista os pacotes que vão para o centro oeste
        if (code_destino.to_i > 200) && (code_destino.to_i  < 300)
            case code_origem.to_i
                when 1..99              # Origem: Sudeste
                    sudeste.append(item)
                when 100..199           # Origem: Sul
                    sul.append(item)    
                when 300..399           # Origem: Nordeste
                    nordeste.append(item)
                else
            end
        end
        
    end

    to_north.each_with_index do |item,id|
        code_origin = item.split(": ")[1].chomp.slice(0..2)
        # adiciona nos caminhoes os pacotes que vao para o Norte
        case code_origin.to_i
            when 1..99              # Origem: Sudeste
                caminhao_sudeste.append(item) 
            when 100..199           # Origem: Sul
                caminhao_sul.append(item)
            when 300..399           # Origem:Nordeste
                caminhao_nordeste.append(item)
            else
        end
    end

    # adiciona nos caminhoes que vao para o Norte
    # os pacotes que vão para o Centro Oeste

    # saindo da região Sudeste
    if  caminhao_sudeste.size != 0    
        for i in 0..sudeste.size
            caminhao_sudeste.append(sudeste[i])
        end
    end
    # saindo da região Sul
    if  caminhao_sul.size != 0      
        for i in 0..sul.size
            caminhao_sul.append(sul[i])
        end
    end  
    # saindo da região Nordeste
    if  caminhao_nordeste.size != 0      
        for i in 0..nordeste.size
            caminhao_nordeste.append(nordeste[i])
        end
    end 
    
    puts "Caminhão rumo ao Norte Partindo do Sul, passando pelo Centro Oeste:"
    if caminhao_sul.size != 0
        puts caminhao_sul
    else
        puts "Atenção: Não possui nenhum pacote com destino ao Norte saindo desta região"
    end      
    puts "\nCaminhão rumo ao Norte Partindo do Sudeste, passando pelo Centro Oeste:"
    if caminhao_sudeste.size != 0
        puts caminhao_sudeste
    else
        puts "Atenção: Não possui nenhum pacote com destino ao Norte saindo desta região"
    end 
    puts "\nCaminhão rumo ao Norte Partindo do Nordeste, passando pelo Centro Oeste:"
    if caminhao_nordeste.size != 0
        puts caminhao_nordeste
    else
        puts "Atenção: Não possui nenhum pacote com destino ao Norte saindo desta região"
    end 

end    

def get_all_packages_to_north(data)
    centro_oeste = []
    norte = []
    resto = []
    fila = []
    data.each_with_index do |item,id|
        code_destino = item.split(": ")[1].chomp.slice(3..5)
        # Definindo a Ordem Centro Oeste - Nordeste - Outros
        case code_destino.to_i
            when 201..299           # Destino : Centro Oeste
                centro_oeste.append(item)    
            when 400..499           # Destino : Nordeste
                norte.append(item)
            else
                resto.append(item)
        end
    end

    # inserindo na fila
    fila.append(centro_oeste) 
    fila.append(norte)
    fila.append(resto)

    puts "Ordem de carga para o Norte, passando pelo Centro Oeste"
    fila.each do |entrega|
        puts entrega
        print "\n"
    end  
    puts "\n" 
end

def get_all_packages_to_north_jewelry_first(data)
    centro_oeste = []
    norte = []
    resto = []
    fila = []
    data.each_with_index do |item,id|
        code_destino = item.split(": ")[1].chomp.slice(3..5)
        code_type = item.split(": ")[1].chomp.slice(12..15)
         # Definindo a Ordem Centro Oeste - Nordeste - Outros
        case code_destino.to_i
            when 201..299           # Sul
                # se for Tipo Jóias, recebe prioridade para descarregar primeiro
                if code_type == "001"           
                    centro_oeste.unshift(item)
                else
                    centro_oeste.append(item)
                end      
            when 400..499           # Nordeste
                if code_type == "001"
                    # se for Tipo Jóias, recebe prioridade para descarregar primeiro
                    norte.unshift(item)
                else
                    norte.append(item)
                end 
            else
                if code_type == "001"
                    # se for Tipo Jóias, recebe prioridade para descarregar primeiro
                    resto.unshift(item)
                else
                    resto.append(item)
                end
        end
    end

    fila.append(centro_oeste) 
    fila.append(norte)
    fila.append(resto)
    puts "Ordem de carga para o Norte, passando pelo Centro Oeste\ncom prioridade para o tipo Jóias\n\n"
    fila.each do |entrega|
        puts entrega
        print "\n"
    end  
    puts "\n" 
end

def get_data_invalid(invalid, data )
    puts "Lista de pacotes inválidos:\n\n"
    invalid.each do |pacote|
        puts data[pacote]
    end 
    print "\n"   
end   

def main
    data = IO.readlines('dados.txt')    #leitura do arquivo
    #Desafio 1
    dest = count_pedidos(data)                                  #q1
    

    #Desafio 2
    data_valid = data                                           #q2
    data_invalid = get_invalid(data_valid)                      #q2

    #Desafio 3
    toy_south = south_toys(data)                                #q3
    
    print "\nDesafio 4\n"
    list_dest = list_destino(data_valid)                        #q4 
    get_list_destino(list_dest)                               #q4
    
    print "\nDesafio 5\n"
    get_list_sellers(data_valid)                               #q5
    
    print "\nDesafio 6\n"
    get_list_dest_type(data_valid)                             #q6
    
    print "\nDesafio 7\n"
    get_list_to_norte_centro_oeste(data_valid)                 #q7 
   
    print "\nDesafio 8\n"
    get_all_packages_to_north(data_valid)                      #q8
    
    print "\nDesafio 9\n"
    get_all_packages_to_north_jewelry_first(data_valid)        #q9
    
    print "\nDesafio 10\n"
    get_data_invalid(data_invalid,data)                         #q10

end

main()