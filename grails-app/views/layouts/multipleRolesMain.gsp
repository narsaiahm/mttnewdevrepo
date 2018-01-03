<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html lang="en" class="no-js">
<!--<![endif]-->
<head>
    <title>Mortality Review Trigger Tool</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <asset:stylesheet src="bootstrap.css"/>
    <asset:javascript src="jquery-2.2.0.min.js"/>
    <asset:javascript src="bootstrap.js"/>
    <asset:stylesheet src="style.css"/>

</head>

<body>

<div class="main-container">
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <div class="col-md-3 fleft">
                <div>
                    <asset:image src="ms_logo.png" style="width: 170px;height: 80px;" />
                </div>
                <div class="heading_2 ">
                    <div>
                        <p><span class="titleName">Mortality Review Trigger Tool</span>
                        </p>
                    </div>
                </div>
            </div>

            <div class="nameRegion col-md-3 fright">
                <div style="width:100%;text-align: right">
                    <g:if test="${session?.user}">
                        <span class=><h5>Welcome ${session?.user?.name}</h5></span>
                    </g:if>
                </div>
                <div class="fright">
                    <a href="#" class="btn btn-info">
                        <span class="glyphicon glyphicon-info-sign"></span> Help
                    </a>
                    <g:link role="button" controller="auth" action="logout" class="btn btn-danger">
                        <span class="glyphicon glyphicon-log-out"></span> Log out
                    </g:link>
                </div>
            </div>
        </div>
    </nav>
    <div class="main-body">
        <g:layoutBody />
    </div>
    <!-- Footer content -->

</div>
<div class="footer">
    <div class="copyrights col-md-4">
        <p>©2017 Mount Sinai Health System</p>
        <p>Mortality Review Trigger Tool v1.0 (2017-08-07) </p>
    </div>
    <div class="col-md-7"></div>
    <div class="col-md-1" style="float:right">
        <a href=":" target="">Contact Us</a>
    </div>
</div>
</body>

</html>
