#!/bin/bash

while true; do
    echo "###############################################################################"
    echo "####################################"
    echo "#####"
	read -p "Insira o usuario ADMINISTRADOR p/ prosseguir instalacao, e clique [ENTER]:" USER

	echo "usuario administrador: " $USER
	echo ""
	read -p "essa informacao esta correta? Y[yes] / N[no] / S[sair]: " resposta



	if [ "$resposta" != "${resposta#[YyNn]}" ];then

		if [ "$resposta" != "${resposta#[Nn]}" ];then
			echo "[N] - nao"

		else
			echo "[Y] - sim"
			USER_VALIDACAO=$USER

			if [ $USER='root' ];then
				localizar=$(sudo cat /etc/passwd | grep /$USER_VALIDACAO:/bin/bash)
			else
				localizar=$(sudo cat /etc/passwd | grep /home/$USER_VALIDACAO:/bin/bash)
			fi
		fi

			if [ -z "$localizar" ];then
				
				echo "Usuario nao foi encontrado: /home/$USER_VALIDACAO:/bin/bash"
				echo "Tente novamente!"
				
			else

				USER_NORMAL=$USER
				break
				exit 1
			
			fi
	else
		echo "finalizando o backup..."
		exit 1	
		
	fi
done


clear;
echo "###############################################################################"
echo "####################################"
echo "#####"
echo " Backup "
echo " "
echo " VERSAO 1.0 "
echo " DEVELOPER:: Marcos Lopes "
echo "#####"
echo "####################################"
echo "###############################################################################"

sleep 2s

ORIGEM=/home/$USER_NORMAL/Downloads/backup/ #diretórios que serão feito backup
DESTINO=/home/$USER_NORMAL/Documentos/ #diretório de destino do backup
DATA=`date +%d-%m-%Y-%k:%M`
TIME_FIND=-1
TIME_DEL=+1

#criação de arquivos e pastas para teste
CAMINHO=$DESTINO/backup/
if [ ! -d "$CAMINHO" ]; then
    cd $DESTINO
    mkdir backup

fi

LOG=$CAMINHO/log

if [ ! -d "$LOG" ]; then
    cd backup/
    mkdir log

fi

ARQUIVOS=$ORIGEM/documento.pdf

if [ ! -e "$ARQUIVOS" ]; then
   cd $ORIGEM
   touch documento.pdf
   touch musica.mp3
   touch trabalho.doc
   touch video.mp4
fi




DESTINO=/home/$USER_NORMAL/Documentos/backup/

chmod 777 -R $DESTINO
chmod 777 -R $ORIGEM

#inicio do backup
dadosdif() {
ARQ=/$DATA.tar
DATAIN=`date +%c`
echo "---------------------------------------------"
echo "Data de inicio: $DATAIN"

}

backupdif(){
echo "---------------------------------------------"
echo "Executando o backup!"
sync

if [ $? -eq 0 ] ; then
   sleep 1s
   DATAFIN=`date +%c`
   echo "---------------------------------------------"
   echo "Gerando log de backup!"
   echo "---------------------------------------------"
   echo "Backup realizado com sucesso!" >> $DESTINO/log/backup.log
   echo "Criado pelo usuário: $USER" >> $DESTINO/log/backup.log
   echo "INICIO: $DATAIN" >> $DESTINO/log/backup.log
   echo "FIM: $DATAFIN" >> $DESTINO/log/backup.log
   echo "------------------------------------------------" >> $DESTINO/log/backup.log
   sleep 1s
   echo "Log gerado em $DESTINO/log/backup.log !"
   echo "---------------------------------------------"

else
   echo "ERRO!!! Backup $DATAIN" >> $DESTINO/log/backup.log
fi  
}

procuraedestroidif(){
#fazendo a eliminação com 5 minutos de diferença para teste
#no final mudar "-mmin +5" para "-mmin +1440" 
find $DESTINO -name *.tar -mmin +1440 -exec rm -f {} ";"
   if [ $? -eq 0 ] ; then
      echo "Eliminando arquivo mais antigo!"
      echo "---------------------------------------------"
      sleep 1s
      echo "Arquivo de backup mais antigo eliminado com sucesso!"
      echo "---------------------------------------------"
   else
      echo "Erro durante a busca e destruição do backup antigo!"
      echo "---------------------------------------------"
   fi
}


dadosdif
backupdif
procuraedestroidif
echo "Iniciando a extração dos arquivos mudados!"
echo "---------------------------------------------"
sleep 2s
tar -cf $ARQ ../backup
mv $ARQ $DESTINO
echo "---------------------------------------------"
echo "Extração dos arquivos concluído com sucesso!"
echo "---------------------------------------------"
echo "Lista de arquivos modificados:"
echo "---------------------------------------------"
rsync -zprav $ORIGEM $DESTINO

echo "###############################################################################"
echo "####################################"
echo "#####"
echo " Backup Finalizado!"
echo "#####"
echo "####################################"
echo "###############################################################################" 
