defmodule BroadConvergeCast do

    def inicia do
        estado_inicial = %{:rec => 0, :soyRaiz => false}
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
        estado = broadConvergeCast(estado)
        {:ok, estado}
    end

    def procesa_mensaje({:mensaje, m}, estado) do
        estado = broadConvergeCast(estado, m)
        {:ok, estado}
    end

    def broadConvergeCast(estado, mensaje \\ nil )

    def broadConvergeCast(estado, {:ok}) do
        %{:id => id, :padre => padre, :hijos => hijos, :rec => rec, :soyRaiz => soyRaiz} = estado
        IO.puts "ID: #{id} M: ok REC: #{rec+1}"
        if rec + 1 == (length hijos) do
            if soyRaiz do
                IO.puts "Proceso terminado"
            else 
                IO.puts "Soy el proceso #{id} y envío OK a mi padre" 
                send padre, {:mensaje, {:ok}}
            end
        end
        Map.put(estado, :rec, rec + 1)
    end

    def broadConvergeCast(estado, m) do
        %{:id => id, :padre => padre, :hijos => hijos, :soyRaiz => soyRaiz} = estado
        IO.puts "ID: #{id} M: #{m}"
        if soyRaiz do
            IO.puts "Soy la raiz #{id} y envío mi id a mis hijos"
            Enum.map(hijos, fn hijo -> send hijo, {:mensaje, id} end) 
        else
            if m != nil do 
                if (length hijos) == 0 do
                    IO.puts "Soy la hoja #{id} y envío OK a mi padre" 
                    send padre, {:mensaje, {:ok}}
                else 
                    IO.puts "Soy el proceso #{id} y envío el mensaje a mis hijos"
                    Enum.map(hijos, fn hijo -> send hijo, {:mensaje, m} end) 
                end 
            end
        end
        estado
    end
end

a = spawn(BroadConvergeCast, :inicia, [])
b = spawn(BroadConvergeCast, :inicia, [])
c = spawn(BroadConvergeCast, :inicia, [])
d = spawn(BroadConvergeCast, :inicia, [])
e = spawn(BroadConvergeCast, :inicia, [])
f = spawn(BroadConvergeCast, :inicia, [])
g = spawn(BroadConvergeCast, :inicia, [])
h = spawn(BroadConvergeCast, :inicia, [])
i = spawn(BroadConvergeCast, :inicia, [])
j = spawn(BroadConvergeCast, :inicia, [])
k = spawn(BroadConvergeCast, :inicia, [])
l = spawn(BroadConvergeCast, :inicia, [])
m = spawn(BroadConvergeCast, :inicia, [])

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


