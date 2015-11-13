<?php 

  // Simple data sharing backend
  // by Lucas Pires Camargo

  header("Content-type: text/plain");
  $filebase = "./data/";


  if(isset($_GET['data']))
  {
    
    // We need an unused number
    $count = 0;
    do
    {
      $number = mt_rand( 10000, 99999 ); 
      $file = "${filebase}$number";
      $count ++;
      if($count > 10000)
      {
	//needs work to better detect when full and what codes are available etc
	echo "FAIL";
	exit(1);
      }
    }
    while(file_exists($file));

    $file_descr = fopen($file, 'w');
    fwrite($file_descr, $_GET['data']);
    fclose($file_descr);
    
    echo($number."\n");
    
    echo "OK\n";
    
  }else
  {
    if(isset($_GET['delete']))
    {
      $file = $filebase . basename($_GET['delete']);
      if(unlink($file))
	echo "OK\n";
      else
	echo "FAIL\n";
      
      echo $file."\n";
    }
    else
    {
      echo "NOP\n";
    }
  }

  
?>
