#!/bin/sh

#  auto-install-arch.sh
#  Created by Rocco Ronzano on 17.08.21
#######################################



echo ""
echo "Auto Installer Arch Linux - V0.1A"
echo ""

mkdir /temp
touch /temp/logs.log
echo "Informations système :"
echo ""
#lscpu | egrep -wi 'intel|amd'
egrep -wi 'intel|amd' /proc/cpuinfo
egrep MemTotal /proc/meminfo
egrep -wi 'nvdia|amd' /proc/gpuinfo


loadkeys fr_CH
timedatectl set-ntp true
timedatectl set-timezone Europe/Zurich
timedatectl status

echo "Avez-vous déjà configuré cet ordinateur ?"
while [[ "$confirmConf" != "Oui" ]]
do
    select confirmConf in Oui Non
    do
        case $confirmConf in
            Non )
                echo "Voulez-vous activer SSH ?"
                select choixSSH in Oui Non
                do
                    case $choixSSH in
                        Oui )
                            sudo systemctl enable sshd
                            sudo systemctl start sshd
                            ssh=1
                            break;;
                        Non )
                            ssh=0
                            echo "OK"
                            break;;
                        * )
                        echo "Valeur inconnue";;
                    esac
                done

                read -p "Entrez un nom pour la machine : " namePC

                read -p "Entrez un username : " nameUser

                read -p "Créez un mot de passe pour le compte $nameUser : " passwdUser1
                read -p "Veuillez confirmer le mot de passe pour le compte $nameUser : " passwdUser2

                while [[ "$passwdUser1" -ne "$passwdUser2" ]]
                do
                    if [[ "$passwdUser1" != "$passwdUser2" ]]
                    then
                        echo ""
                        echo "Une erreur est survenue, les mots de passes ne sont pas identiques, veuillez recommencer !"
                        echo ""
                    fi
                    read -p "Créez un mot de passe pour le compte $nameUser : " passwdUser1
                    read -p "Veuillez confirmer le mot de passe pour le compte $nameUser : " passwdUser2
                done
                echo ""
                echo "Mot de passe créé/modifié avec succès !"

                echo ""

                echo "Voulez-vous changer votre mot de passe root ?"
                while [[ "$choixPasswdRoot" != "Non" ]]
                do
                    select choixPasswdRoot in Oui Non
                    do
                        case $choixPasswdRoot in
                            Oui )
                                read -p "Créez un mot de passe pour le compte root : " passwdRoot1
                                read -p "Veuillez confirmer le mot de passe pour le compte root : " passwdRoot2
                                while [[ "$passwdRoot1" -ne "$passwdRoot2" ]]
                                do
                                    if [[ "$passwdRoot1" != "$passwdRoot2" ]]
                                    then
                                        echo ""
                                        echo "Une erreur est survenue, les mots de passes ne sont pas identiques, veuillez recommencer !"
                                        echo ""
                                    fi
                                    read -p "Créez un mot de passe pour le compte root : " passwdRoot1
                                    read -p "Veuillez confirmer le mot de passe pour le compte root : " passwdRoot2
                                done
                                echo ""
                                echo "Mot de passe créé/modifié avec succès !"
                                echo ""
                                echo "Voulez-vous changer votre mot de passe root ?"
                                break;;
                            Non )
                                echo "ok"
                                echo ""
                                break;;
                            * )
                                echo ""
                                echo "Valeur inconnue"
                                echo "";;
                        esac
                    done
                done

                echo "Quel système utilisez-vous ?"
                select choixFormatSystem in Bios/MBR UEFI Reboot
                do
                    case $choixFormatSystem in
                        Bios/MBR )
                            formatSystem=Bios/MBR
                            break;;
                        UEFI )
                            formatSystem=UEFI
                            break;;
                        Reboot )
                            sudo reboot
                            break;;
                        * )
                        echo "Valeur inconnue";;
                    esac
                done

                echo ""

                echo "Quel stockage voulez-vous pour la partition SWAP ?"
                read -p "Exemple : +4G = 4Gio de partion SWAP, il est recommandé d'avoir l'équivalant ou le double de mémoire par rapport à la RAM : " swapSize
                while [[ "$choixSwapSize" != "Oui" ]]
                do
                    echo "vous avez choisis $swapSize en terme de stockage SWAP, est-ce correct ?"
                    select choixSwapSize in Oui Non
                    do
                        case $choixSwapSize in
                            Oui )
                                echo ""
                                echo "Parfait !"
                                echo ""
                                break;;
                            Non )
                                echo "Quel stockage voulez-vous pour la partition SWAP ?"
                                read -p "Exemple : +4G = 4Gio de partion SWAP, il est recommandé d'avoir l'équivalant ou le double de mémoire par rapport à la RAM : " swapSize
                                echo ""
                                break;;
                            * )
                                echo ""
                                echo "Valeur inconnue"
                                echo "";;
                        esac
                    done
                done

                echo "Etat ssh" $ssh
                echo "Nom de l'ordinateur : " $namePC
                echo "Nom de l'utilisateur : " $nameUser
                echo "Mot de passe de $nameUser : " $passwdUser1
                echo "Mot de passe root : " $passwdRoot1
                echo "Format du système : " $formatSystem
                echo "Taille du SWAP : " $swapSize
                echo ""
                echo "Voici la configuration, êtes-vous sûr-e ?"
                break;;
            Oui )
                echo ""
                echo "Prafait ! Suite du script en cours..."
                echo ""
                
                break;;
            * )
                echo ""
                echo "Valeur inconnue"
                echo "";;
        esac
    done
done




echo "Bye bye !"
echo ""