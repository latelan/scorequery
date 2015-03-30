<?php
/*
 * 
 */

$data = $argv[1];

show_score(get_score_list($data));

function get_score_list($data){
	$reg = '/<Table.*?\">(.*?)<\/Table>/s';
	$res = preg_match_all($reg,$data,$out,PREG_PATTERN_ORDER);
	$scores = array();
	foreach($out[1] as $item){
		$score = array();
		$score = get_score($item);
		
		$scores[] = $score;	
	}
	print_r($scores);
	return $scores;
}

function get_score($data){
	$data = iconv('gb2312','utf-8',$data);
	$matchers = array('kcmc' => '/<KCMC>(.*?)<\/KCMC>/',
				'pscj' => '/<PSCJ>(.*?)<\/PSCJ>/',
				'cj' => '/<CJ>(.*?)<\/CJ>/',
				'qmcj' => '/<QMCJ>(.*?)<\/QMCJ>/');
	$scores = array();
	foreach($matchers as $key => $value) {
		$res = preg_match($value,$data,$out);
		if($res > 0){
			$scores[$key] = $out[1];
		} else {
			$scores[$key] = '';
		}	
	}

	return $scores;
}

function show_score($data)
{
	if(!is_array($data)) {
		echo "Not Found.";
	}
	echo " 课程名称\t\t 最终成绩\t 平时成绩\t 卷面成绩\n";
	foreach($data as $score) {
		echo $score['kcmc'] ."\t\t " .$score['cj'] ."\t " .$score['pscj'] ."\t " .$score['qmcj'] ."\n";
	}
}
?>
