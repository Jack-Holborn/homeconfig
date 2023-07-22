#!/usr/bin/perl
# (C)2023 Jack Holborn <jack_holborn@hotmail.com>
# script perl récupéré je sais plus où mais la connaissance se partage ...
# Récupération des mails par POP3
# - en sortie une phrase par boite
# - pour l'exemple 1 boite
# - on peut en rajouter

use strict;
use Net::POP3;

##################" Première Boite courriel #############################
# -------------
# Entrez le nom de votre serveur pop3 ici
# -------------
my $ServerName = "lorinas.homelinux.lan";

# -------------
# Si votre nom d'utilisateur contient un caractère @ 
# vous devez le remplacer par \@
# -------------
my $UserName = "userone";

# -------------
# Entrez votre mot de passe ici, pensez à chmod 600
#  -------------
my $Password = "****************";

# Connexion au serveur POP
my $pop3 = Net::POP3->new($ServerName);
die "Couldn't log on to server" unless $pop3;

# Récupère le nombre de message
my $Num_Messages1 = $pop3->login($UserName, $Password) + 0;

# Quit connection to pop3 server
$pop3->quit();

# Ecrit la sortie
#print "$UserName chez $ServerName: $Num_Messages1 \n";
print "$Num_Messages1 \n";

##################"  La deuxième boite #############################
# Ici vous pouvez recopier le contenu de la première boite pour vos autres boites

exit 0;
