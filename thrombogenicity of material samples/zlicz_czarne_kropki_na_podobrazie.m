function liczba_czarnych_kropek = zlicz_czarne_kropki_na_podobrazie(podobraz)
    % Próg binarizacji - wartość piksela poniżej tego progu będzie uważana za czarną kropkę
    prog = 50;  % Możesz dostosować ten próg do swoich potrzeb

    % Binarnizacja podobrazu: 1 - czarna kropka, 0 - tło
    podobraz_binarny = podobraz < prog;

    % Etykietowanie obiektów na obrazie binarnym
    etykiety = bwlabel(podobraz_binarny);

    % Analiza właściwości obiektów i zliczenie czarnych kropek
    regiony = regionprops(etykiety, 'Area');

    % Zliczanie czarnych kropek o określonym obszarze (dla przykładu, zakładamy, że kropka ma obszar mniejszy niż 100 pikseli)
    obszar_kropki = 100;  % Możesz dostosować ten obszar do swoich potrzeb
    liczba_czarnych_kropek = sum([regiony.Area] < obszar_kropki);
end