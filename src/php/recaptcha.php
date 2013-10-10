<?php

require_once("recaptchalib.php");

if ($_POST["recaptcha_response_field"]) {
  $privatekey = "6LcsROcSAAAAAKCf2RFH6lo_Q0v30r9Tn5u-CQdt";
  
  $resp = recaptcha_check_answer($privatekey, $_SERVER["REMOTE_ADDR"], $_POST["recaptcha_challenge_field"], $_POST["recaptcha_response_field"]);
  
  if ($resp->is_valid) {
    $status = true;
  } else {
    # set the error code so that we can display it
    $error = $resp->error;
    $status = false;
  }
}

header('Content-type: application/json');
echo $status;

?>