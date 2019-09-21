defmodule Cadena do
    def inicia do
        estado_inicial = %{:procesado => false}
        recibe_mensaje(estado_inicial)
    end

    def recibe_mensaje(estado) do
        receive do
        mensaje ->
            {:ok, nuevo_estado} = procesa_mensaje(mensaje, estado)
            recibe_mensaje(nuevo_estado)
        end 
    end


    def procesa_mensaje({:id, id}, estado) do
        estado = Map.put(estado, :id, id)
        {:ok, estado}
    end

    def procesa_mensaje({:vecinos, vecinos}, estado) do
        estado = Map.put(estado, :vecinos, vecinos)
        {:ok, estado}
    end

    def procesa_mensaje({:inicia}, estado) do
        estado = cadena(estado)
        {:ok, estado}
    end

    def procesa_mensaje({:mensaje, n_id}, estado) do
        estado = cadena(estado, n_id)
        {:ok, estado}
    end

    def cadena(estado, n_id \\ nil) do
        %{:id => id, :vecinos => vecinos, :procesado => procesado} = estado
        IO.puts "ID: #{id} N_ID: #{n_id}"
        if id == 1 and (not procesado) do
            IO.puts "Soy el proceso inicial y envío mi id = #{id} a todos"
            Enum.map(vecinos, fn vecino -> send vecino, {:mensaje, id} end)
            Map.put(estado, :procesado, true)
        else
            if n_id != nil and id == (n_id + 1) and (not procesado) do
                IO.puts "Soy el proceso #{id} y procesé el mensaje #{(n_id)}"
                Enum.map(vecinos, fn vecino -> send vecino, {:mensaje, id} end)
                Map.put(estado, :procesado, true)
            else 
                estado
            end 
        end
    end
end


a = spawn(Cadena, :inicia, [])
b = spawn(Cadena, :inicia, [])
c = spawn(Cadena, :inicia, [])
send a, {:id, 1}
send b, {:id, 2}
send c, {:id, 3}
send a, {:vecinos, [b, c]}
send b, {:vecinos, [a, c]}
send c, {:vecinos, [a, b]}
send a, {:inicia}
send b, {:inicia}
send c, {:inicia}
