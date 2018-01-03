<div class="col-sm-3">
    <g:form controller="mortality" name="adminSearchForm" action="displaySearchResults">
        <div class="form-group margin">
            <label class="control-label">Form Status</label>
            <br>
            <label id="all" class="radio-inline">
                <input type="radio" id="formStatus_all" name="formStatus" value="ALL" checked="checked">All
            </label>
            <label id="unAssigned&incomplete" class="radio-inline">
                <input type="radio" id="formStatus_unassigned" name="formStatus"
                       value="UNASSIGNED" ${params?.formStatus=='UNASSIGNED'?'checked="checked"':''}>Unassigned & Incomplete
            </label>
            <label class="radio-inline">
                <input name="formStatus" id="formStatus_complete" type="radio" value="SUBMITTED" ${params?.formStatus=='SUBMITTED'?'checked="checked"':''}>Complete & Submitted
            </label>
            <label class="radio-inline">
                <input name="formStatus" id="formStatus_completeAmended" type="radio" value="AMENDED" ${params?.formStatus=='AMENDED'?'checked="checked"':''}>Complete & Amended
            </label>
        </div>

        <div class="form-group margin">
            <label>MSHS Hospital</label>
            <g:select class="form-control" from="${facilityMap}"
                      name="facility" optionKey="key" optionValue="value" value="${params?.facility}"
                      onchange="updateDeptQl(this)" noSelection="['': 'All']"></g:select>
        </div>

        <div id="form_dept_ql">
            <g:render template="/mortality/templates/adminSearchDeptQL"/>
        </div>

        <!-- start of first date part -->
        <div class="margin">
            <label id="dateOfDeathFirstLabel" class="radio-inline">
                <input type="radio" id="dateDeathFirstRadio" name="dateOfDeathRadio" value="dateOfDeath" ${params?.dateOfDeathRadio=='dateOfDeath'?'checked="checked"':''}
                       onclick="hideDateOfDeathDatePicker(this)">Date of Death
            </label>
            <label id="dateOfDeathSecLabel" class="radio-inline">
                <input id="dateDeathSecRadio" name="dateOfDeathRadio" type="radio" ${params?.dateOfDeathRadio=='deathRange'?'checked="checked"':''}
                       value="deathRange">Date of Death Range
            </label>

        </div>
        <br>

        <div id="dateOfDeathFirstDiv">
            <p>
                <input type="text" id='dateOfDeath' class="datePicker form-control" name="dateOfDeath" value="${params.dateOfDeath}"
                       disabled="true">
            </p>
        </div>

        <div class="form-group text" id='dateOfDeathSecondDiv' style='display:none'>
            <label>From:</label>
            <input type="text" id='fromDeathDate' class="datePicker form-control" name='fromDeathDate' value="${params.fromDeathDate}">
            <span id="align">
                <label>To:</label>
                <input type="text" id='toDeathDate' class="datePicker form-control" name='toDeathDate' value="${params.toDeathDate}">
            </span>
        </div>
        <!-- second Date -->
        <div class="margin">
            <label id="dateCompletedFirstLabel" class="radio-inline">
                <input id="dateCompletedFirstRadio" type="radio" name="dateCompletedRadio" value="dateCompleted" ${params?.dateCompletedRadio=='dateCompleted'?'checked="checked"':''}
                       onclick="hideDateCompleteDatePicker(this)">Date Completed
            </label>
            <label id="dateCompletedSecLabel" class="radio-inline">
                <input id="dateCompletedSecRadio" name="dateCompletedRadio" type="radio" ${params?.dateCompletedRadio=='completedRange'?'checked="checked"':''}
                       value="completedRange">Date Completed Range
            </label>
        </div>
        <br>

        <div id="dateCompletedFirstDiv">
            <p>
                <input type="text" id="dateCompleted" class="datePicker form-control" name="dateCompleted" value="${params.dateCompleted}"
                       disabled="true">
            </p>
        </div>

        <div class="form-group text" id='dateCompletedSecDiv' style='display:none'>
            <label>From:</label>
            <input type="text" id='fromDateCompleted' class="datePicker form-control" name="fromDateCompleted" value="${params.fromDateCompleted}">
            <span id="align1">
                <label>To:</label>
                <input type="text" id='toDateCompleted' class="datePicker form-control" name="toDateCompleted" value="${params.toDateCompleted}">
            </span>
        </div>

        <div class="margin">
            <label class="checkbox-inline">
                <input type="checkbox" id="requiredFurtherReview"  ${params?.requiredFurtherReview=="on"?'checked="checked"':''}
                       name="requiredFurtherReview">Does Death Require Further Review?
            </label>
        </div>

        <div class="margin">
            <label class="checkbox-inline">
                <input type="checkbox" id="expectedPatToDieAdmission"  ${params?.expectedPatToDieAdmission=="on"?'checked="checked"':''}
                       name="expectedPatToDieAdmission">Would you have expected the patient to die during this admission?
            </label>
        </div>

        <div class="form-group row margin">
            <label class="col-sm-5 col-form-label">Patient MRN
            </label>

            <div class="col-sm-7  ">
                <input class="form-control" type="text" name="mrn" value="${params.mrn}">
            </div>
        </div>

        <div class="form-group row margin">
            <label class="col-sm-5 col-form-label">Patient Name
            </label>

            <div class="col-sm-7  ">
                <input class="form-control" type="text" name="patientName" value="${params.patientName}">
            </div>
        </div>


        <div class="col-sm-12">
            <div class="row margin">
                <button type="button" class="btn btn-primary btn-sm" id="search" onclick="adminSearch(this);"
                        value="">Display</button>

                <g:link controller=" Mortality" action="adminDashboard"
                        class="btn btn-primary btn-sm cancelButton" params="[clearFilter:true]">Clear Filter</g:link>
                <g:actionSubmit value="Export Data" action="exportData" class="btn btn-primary btn-sm"
                                onclick="this.form.action='${createLink(action: 'exportData')}';"></g:actionSubmit>
            </div>
        </div>

    </g:form>
</div>