<%@ page import="org.mountsinai.mortalitytriggersystem.MortalityConstants" %>
<!DOCTYPE html>
<html>

<head>
    <head>
        <meta name="layout" content="main"/>
    </head>
</head>

<body>

<div class="col-md-12">
    <div class="runReportSidebar col-md-3">
        <span class = "runReportLink" onclick="showReport('mtt_summary_report')">MRTT Summary Report</span>
        <br><br>
        <span class = "runReportLink" onclick="showReport('mtt_time_to_completion_report')">Time to Completion</span>
    </div>

    <div class="col-md-9 iframeDiv" id="mtt_summary_report" >
        <iframe  class = "runReportIframe" src="${MortalityConstants.MRTT_SUMMARY_REPORT_URL}"></iframe>
    </div>

    <div class="col-md-9 iframeDiv" style="display: none" id="mtt_time_to_completion_report">
        <iframe class = "runReportIframe" src="${MortalityConstants.MRTT_TIME_TO_COMPLETION_REPORT_URL}"></iframe>
    </div>
</div>
<script>
    $(document).ready(function() {
        $('.onlyOnReportPage').show();
    });
</script>
</body>
</html>