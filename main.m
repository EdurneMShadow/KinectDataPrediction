load data;
skel_model;
resultados = zeros(100:2);
for i = 1:100
  %División en train y test
  rp = randperm(length(individuals));
  index_train = ismember(individuals, rp(1:60));
  index_test = ~index_train;

  %Entrenamiento de los modelos
  model_bayes = learn_model(data(:,:,index_train), labels(index_train));
  model = learn_model(data(:,:,index_train), labels(index_train), nui_skeleton_conn);

  %Clasificación
  p_bayes=classify_instances(data(:,:,index_test), model_bayes);
  p_lg=classify_instances(data(:,:,index_test), model);

  %Cálculo del acierto
  [v_bayes,ii_bayes]=max(p_bayes,[],2);
  ii_bayes(ii_bayes==4)=8;
  resultados(i,1) = mean(labels(index_test)==ii_bayes);
  
  [v_lg,ii_lg]=max(p_lg,[],2);
  ii_lg(ii_lg==4)=8;
  resultados(i,2) = mean(labels(index_test)==ii_lg);
end
