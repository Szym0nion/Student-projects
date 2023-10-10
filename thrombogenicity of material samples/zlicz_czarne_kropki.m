function liczba_czarnych_kropek = zlicz_czarne_kropki(obraz)
    % Próg binarizacji - wartość piksela poniżej tego progu będzie uważana za czarną kropkę
    prog = 50;  % Możesz dostosować ten próg do swoich potrzeb

    % Przekształć obraz na odcienie szarości, jeśli nie jest już w odcieniach szarości
    if size(obraz, 3) == 3
        obraz = rgb2gray(obraz);
    end

    % Binarnizacja obrazu: 1 - czarna kropka, 0 - tło
    obraz_binarny = obraz < prog;

    % Etykietowanie obiektów na obrazie binarnym
    etykiety = bwlabel(obraz_binarny);

    % Analiza właściwości obiektów i zliczenie czarnych kropek
    regiony = regionprops(etykiety, 'Area');

    % Zliczanie czarnych kropek o określonym obszarze (dla przykładu, zakładamy, że kropka ma obszar mniejszy niż 100 pikseli)
    obszar_kropki = 100;  % Możesz dostosować ten obszar do swoich potrzeb
    liczba_czarnych_kropek = sum([regiony.Area] < obszar_kropki);
end