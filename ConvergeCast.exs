defmodule ConvergeCast do

    def inicia do
        estado_inicial = %{:rec => 0, :soyRaiz => false, :recibidos => []}
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

    def procesa_mensaje({:soyRaiz}, estado) do
        estado = Map.put(estado, :soyRaiz, true)
        {:ok, estado}
    end

    def procesa_mensaje({:padre, padre}, estado) do
        estado = Map.put(estado, :padre, padre)
        {:ok, estado}
    end

    def procesa_mensaje({:hijos, hijos}, estado) do
        estado = Map.put(estado, :hijos, hijos)
        {:ok, estado}
    end

    def procesa_mensaje({:inicia}, estado) do
        estado = convergeCast(estado)
        {:ok, estado}
    end

    def procesa_mensaje({:ok, id}, estado) do
        estado = convergeCast(estado, id)
        {:ok, estado}
    end

    def convergeCast(estado, m \\ nil) do
        %{:id => id, :padre => padre, :hijos => hijos, :rec => rec, :soyRaiz => soyRaiz, :recibidos => recibidos} = estado
        IO.puts "ID: #{id} M: #{m}"
        if (length hijos) == 0 do
            IO.puts "Soy la hoja #{id} y envío mi ID a mi padre"
            send padre, {:ok, id} 
            estado
        else
            if m != nil do
                IO.puts "Soy el proceso #{id} y he recibido: #{Enum.join([m|recibidos], ",")}"
                if rec + 1 == (length hijos) do
                    if soyRaiz do
                        IO.puts "Proceso terminado"
                    else
                        IO.puts "Soy el proceso #{id} y envío mi ID a mi padre"
                        send padre, {:ok, id}
                    end
                end
                estado = Map.put(estado, :rec, rec + 1)
                Map.put(estado, :recibidos, [m|recibidos])
            else
                estado
            end
        end
    end
end

a = spawn(ConvergeCast, :inicia, [])
b = spawn(ConvergeCast, :inicia, [])
c = spawn(ConvergeCast, :inicia, [])
d = spawn(ConvergeCast, :inicia, [])
e = spawn(ConvergeCast, :inicia, [])
f = spawn(ConvergeCast, :inicia, [])
g = spawn(ConvergeCast, :inicia, [])
h = spawn(ConvergeCast, :inicia, [])
i = spawn(ConvergeCast, :inicia, [])
j = spawn(ConvergeCast, :inicia, [])
k = spawn(ConvergeCast, :inicia, [])
l = spawn(ConvergeCast, :inicia, [])
m = spawn(ConvergeCast, :inicia, [])

send a, {:id, 1}
send b, {:id, 2}
send c, {:id, 3}
send d, {:id, 4}
send e, {:id, 5}
send f, {:id, 6}
send g, {:id, 7}
send h, {:id, 8}
send i, {:id, 9}
send j, {:id, 10}
send k, {:id, 11}
send l, {:id, 12}
send m, {:id, 13}

send k, {:soyRaiz}

send a, {:padre, d}
send b, {:padre, k}
send c, {:padre, i}
send d, {:padre, e}
send e, {:padre, k}
send f, {:padre, h}
send g, {:padre, e}
send h, {:padre, k}
send i, {:padre, j}
send j, {:padre, h}
send k, {:padre, nil}
send l, {:padre, a}
send m, {:padre, a}

send a, {:hijos, [l,m]}
send b, {:hijos, []}
send c, {:hijos, []}
send d, {:hijos, [a]}
send e, {:hijos, [d,g]}
send f, {:hijos, []}
send g, {:hijos, []}
send h, {:hijos, [f,j]}
send i, {:hijos, [c]}
send j, {:hijos, [i]}
send k, {:hijos, [b,e,h]}
send l, {:hijos, []}
send m, {:hijos, []}

send a, {:inicia}
send b, {:inicia}
send c, {:inicia}
send d, {:inicia}
send e, {:inicia}
send f, {:inicia}
send g, {:inicia}
send h, {:inicia}
send i, {:inicia}
send j, {:inicia}
send k, {:inicia}
send l, {:inicia}
send m, {:inicia}


