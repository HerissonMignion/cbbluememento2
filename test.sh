#!/bin/bash



# TODO: apprendre bats tant qu'à faire



previous_exit_code=0;
stdouterr_filepath=$(mktemp);

# rouler le script
run() {
	echo "### run" "$@";
	bash cbbluememento2.sh "$@" &> "$stdouterr_filepath";
	previous_exit_code=$?;
}

# rouler une commande dans le script. c'est juste une fonction raccourci.
funcrun() {
	run test -- "$@";
}



exited() {
	local expected_code=$1;
	if ! [ "$expected_code" == "$previous_exit_code" ]; then
		echo "ERROR: Expected exit code $expected_code, but it exited with $previous_exit_code";
		echo;
	fi;
}

# donner le texte de comparaison via le stdin de la commande
printed() {
	# noter que les commandes substitution stripent les trailing newlines.
	local expected=$(cat);
	local actual=$(cat "$stdouterr_filepath");
    if ! [ "$expected" == "$actual" ]; then
		echo "ERROR: Expected stdout and stderr:";
		echo "$expected";
		echo "ERROR: but instead got:";
		echo "$actual";
		echo;
	fi;
}





test_human_time_tests() {
	funcrun test_human_time 00:00;
	exited 0;
	
	funcrun test_human_time 00:-00;
	exited 1;
	
	funcrun test_human_time 00:0;
	exited 1;

	funcrun test_human_time :00;
	exited 1;

	funcrun test_human_time :;
	exited 1;

	funcrun test_human_time 00:;
	exited 1;

	funcrun test_human_time "";
	exited 1;
	
	funcrun test_human_time -00:00;
	exited 1;
	
	funcrun test_human_time " 00:00";
	exited 1;
	
	funcrun test_human_time 0:00;
	exited 0;
	
	funcrun test_human_time 8:00;
	exited 0;
	
	funcrun test_human_time -8:00;
	exited 1;
	
	funcrun test_human_time 17:32;
	exited 0;
	
	funcrun test_human_time 17:32a;
	exited 1;
	
	funcrun test_human_time a17:32;
	exited 1;
	
	funcrun test_human_time "17 :32";
	exited 1;
	
	funcrun test_human_time "17a:32";
	exited 1;
	
	funcrun test_human_time "17: 32";
	exited 1;
	
	funcrun test_human_time 17:-32;
	exited 1;
}

convert_human_time_to_int_tests() {
	local name=convert_human_time_to_int;

	# il faut make sure que quand les minutes ou les heures sont
	# inférieur à 10 (commence par un 0), alors bash ne fait pas une
	# erreur parce qu'il pense que c'est en octal, et que 8 et 9 sont
	# des digits qui n'existent pas en octal.

	funcrun $name 0:07;
	printed <<<7;

	funcrun $name 0:08;
	printed <<<8;

	funcrun $name 0:09;
	printed <<<9;

	funcrun $name 0:10;
	printed <<<10;

	funcrun $name 0:11;
	printed <<<11;

	funcrun $name 07:00;
	printed <<<420;

	funcrun $name 08:00;
	printed <<<480;

	funcrun $name 09:00;
	printed <<<540;

	funcrun $name 10:00;
	printed <<<600;

	funcrun $name 11:00;
	printed <<<660;

	funcrun $name 07:08;
	printed <<<428;

	funcrun $name 08:08;
	printed <<<488;

	funcrun $name 09:08;
	printed <<<548;

	funcrun $name 10:08;
	printed <<<608;

	funcrun $name 11:08;
	printed <<<668;

	
	
	funcrun $name -0:07;
	printed <<<-7;

	funcrun $name -0:08;
	printed <<<-8;

	funcrun $name -0:09;
	printed <<<-9;

	funcrun $name -0:10;
	printed <<<-10;

	funcrun $name -0:11;
	printed <<<-11;

	funcrun $name -07:00;
	printed <<<-420;

	funcrun $name -08:00;
	printed <<<-480;

	funcrun $name -09:00;
	printed <<<-540;

	funcrun $name -10:00;
	printed <<<-600;

	funcrun $name -11:00;
	printed <<<-660;

	funcrun $name -07:08;
	printed <<<-428;

	funcrun $name -08:08;
	printed <<<-488;

	funcrun $name -09:08;
	printed <<<-548;

	funcrun $name -10:08;
	printed <<<-608;

	funcrun $name -11:08;
	printed <<<-668;



	funcrun $name 0:00;
	printed <<<0;

	funcrun $name -0:00;
	printed <<<0;

	funcrun $name 00:00;
	printed <<<0;

	funcrun $name -00:00;
	printed <<<0;

	

	funcrun $name 08:01;
	printed <<<481;

	funcrun $name 0:15;
	printed <<<15;
}

convert_int_to_human_time_tests() {
	local name=convert_int_to_human_time;

	funcrun $name 0;
	printed <<<0:00;

	funcrun $name 1;
	printed <<<0:01;

	funcrun $name 2;
	printed <<<0:02;
	
	funcrun $name 3;
	printed <<<0:03;
	
    funcrun $name 4;
	printed <<<0:04;
	
	funcrun $name 5;
	printed <<<0:05;
	
	funcrun $name 6;
	printed <<<0:06;
	
	funcrun $name 7;
	printed <<<0:07;
	
	funcrun $name 8;
	printed <<<0:08;
	
	funcrun $name 9;
	printed <<<0:09;
	
	funcrun $name 10;
	printed <<<0:10;
	
	funcrun $name 11;
	printed <<<0:11;
	
	funcrun $name 12;
	printed <<<0:12;

	funcrun $name 00;
	printed <<<0:00;

	funcrun $name 01;
	printed <<<0:01;

	funcrun $name 02;
	printed <<<0:02;
	
	funcrun $name 03;
	printed <<<0:03;
	
    funcrun $name 04;
	printed <<<0:04;
	
	funcrun $name 05;
	printed <<<0:05;
	
	funcrun $name 06;
	printed <<<0:06;
	
	funcrun $name 07;
	printed <<<0:07;
	
	funcrun $name 08;
	printed <<<0:08;
	
	funcrun $name 09;
	printed <<<0:09;
	
	funcrun $name 010;
	printed <<<0:10;
	
	funcrun $name 011;
	printed <<<0:11;
	
	funcrun $name 012;
	printed <<<0:12;


	
	funcrun $name -0;
	printed <<<0:00;

	funcrun $name -1;
	printed <<<-0:01;

	funcrun $name -2;
	printed <<<-0:02;
	
	funcrun $name -3;
	printed <<<-0:03;
	
    funcrun $name -4;
	printed <<<-0:04;
	
	funcrun $name -5;
	printed <<<-0:05;
	
	funcrun $name -6;
	printed <<<-0:06;
	
	funcrun $name -7;
	printed <<<-0:07;
	
	funcrun $name -8;
	printed <<<-0:08;
	
	funcrun $name -9;
	printed <<<-0:09;
	
	funcrun $name -10;
	printed <<<-0:10;
	
	funcrun $name -11;
	printed <<<-0:11;
	
	funcrun $name -12;
	printed <<<-0:12;

	funcrun $name -00;
	printed <<<0:00;

	funcrun $name -01;
	printed <<<-0:01;

	funcrun $name -02;
	printed <<<-0:02;
	
	funcrun $name -03;
	printed <<<-0:03;
	
    funcrun $name -04;
	printed <<<-0:04;
	
	funcrun $name -05;
	printed <<<-0:05;
	
	funcrun $name -06;
	printed <<<-0:06;
	
	funcrun $name -07;
	printed <<<-0:07;
	
	funcrun $name -08;
	printed <<<-0:08;
	
	funcrun $name -09;
	printed <<<-0:09;
	
	funcrun $name -010;
	printed <<<-0:10;
	
	funcrun $name -011;
	printed <<<-0:11;
	
	funcrun $name -012;
	printed <<<-0:12;
	





	
	# here
	
	funcrun $name 420;
	printed <<<7:00;

	funcrun $name 480;
	printed <<<8:00;

	funcrun $name 540;
	printed <<<9:00;

	funcrun $name 600;
	printed <<<10:00;

	funcrun $name 660;
	printed <<<11:00;

	funcrun $name 428;
	printed <<<7:08;

	funcrun $name 488;
	printed <<<8:08;

	funcrun $name 548;
	printed <<<9:08;

	funcrun $name 608;
	printed <<<10:08;

	funcrun $name 668;
	printed <<<11:08;

	
	
	funcrun $name -7;
	printed <<<-0:07;

	funcrun $name -8;
	printed <<<-0:08;

	funcrun $name -9;
	printed <<<-0:09;

	funcrun $name -10;
	printed <<<-0:10;

	funcrun $name -11;
	printed <<<-0:11;

	funcrun $name -420;
	printed <<<-7:00;

	funcrun $name -480;
	printed <<<-8:00;

	funcrun $name -540;
	printed <<<-9:00;

	funcrun $name -600;
	printed <<<-10:00;

	funcrun $name -660;
	printed <<<-11:00;

	funcrun $name -428;
	printed <<<-7:08;

	funcrun $name -488;
	printed <<<-8:08;

	funcrun $name -548;
	printed <<<-9:08;

	funcrun $name -608;
	printed <<<-10:08;

	funcrun $name -668;
	printed <<<-11:08;


	

	
}

main() {
	test_human_time_tests;
	convert_human_time_to_int_tests;
	convert_int_to_human_time_tests;
}


main "$@";
rm "$stdouterr_filepath";

