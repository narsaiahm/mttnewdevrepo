<%@ page import="org.mountsinai.mortalitytriggersystem.MortalityConstants" %>
<div class="col-md-12">
    <span class="fright">Loaded <g:formatDate format="EEE MM-dd-yyyy HH:mm:ss" date="${new Date()}"/></span>
</div>
<div id="refresh" class="col-md-12">
    <div class="tableArea">
        <div class="row">
            <span class="textTitle">Assigned: Not Accepted</span>
            <div class="col-md-12 margin_top_-10">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover tableQlead">
                        <thead>
                        <tr class="tableRow">
                            <th>Action</th>
                            <th>Patient Name</th>
                            <th>Hospital</th>
                            <th>Discharge Date</th>
                            <th>Discharging Unit</th>
                            <th>Specialty</th>
                            <th>Status Date/Time</th>
                            <th>Status</th>
                            <th>Status History</th>
                        </tr>
                        </thead>
                        <tbody>
                        <g:each in="${reviewList}" var="reviewInfo">
                            <g:if test="${reviewInfo.status?.equals(MortalityConstants.ASSIGNED) || reviewInfo.status?.equals(MortalityConstants.REASSIGNED)}">
                                <tr class="tableRow">
                                    <td>

                                        <button type="submit" class="btn btn-primary btnQualityLead btn-xs"
                                                id="accept"
                                                onclick="acceptReviewForm(${reviewInfo?.id}, '${reviewInfo?.status}');"
                                                value="${reviewInfo?.id}">Accept</button>&nbsp;

                                        <g:link action="assignReviewForm"
                                                params="[reviewId: reviewInfo?.id, reviewFacilityCode: reviewInfo?.facilityCode, status: reviewInfo?.status, patientName: reviewInfo?.patientName, mrn: reviewInfo?.mrn,lead:reviewInfo?.lead,role:reviewInfo?.role,isReviewForm:false]">
                                            <button type="button"
                                                    class="btn btn-primary btn-xs btnQualityLead btn-xs">Reassign</button>
                                        </g:link>

                                    </td>
                                    <td><g:link action="review"
                                                params="[reviewId: reviewInfo?.id]">
                                        <span>${reviewInfo?.patientName}</span></g:link></td>

                                    <td><span>${reviewInfo?.facilityCode}</span></td>
                                    <td><span>${reviewInfo?.dischargeDateTime}</span></td>
                                    <td><span>${reviewInfo?.dischargeUnit}</span></td>
                                    <td><span>${reviewInfo?.dischargingDivision}</span></td>
                                    <td><span>${reviewInfo?.statusDateTime}</span></td>
                                    <td><span>${reviewInfo?.statusStr? reviewInfo?.statusStr : reviewInfo?.status}</span></td>
                                    <td>
                                        <button type="button" id="showHistory_${reviewInfo?.id}"
                                                class="btn btn-primary btnQualityLead btn-xs"
                                                onclick="showHistory(${reviewInfo?.id}, this)">Show History</button>
                                    </td>
                                </tr>
                            </g:if>
                        </g:each>
                        <g:if test="${reviewList.grep{it -> it.status?.equals(MortalityConstants.ASSIGNED) || it.status?.equals(MortalityConstants.REASSIGNED)}.size()==0}">
                            <tr><td colspan="9">No records found</td></tr>
                        </g:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="row">
            <span class="textTitle">Accepted: Incomplete</span>
            <div class="col-md-12 margin_top_-10">
                <div class="table-responsive">
                    <table id="example" class="table table-striped table-bordered table-hover tableQlead">
                        <thead>
                        <tr class="tableRow">
                            <th>Action</th>
                            <th>Patient Name</th>
                            <th>Hospital</th>
                            <th>Discharge Date</th>
                            <th>Discharging Unit</th>
                            <th>Specialty</th>
                            <th>Status Date/Time</th>
                            <th>Status</th>
                            <th>Status History</th>
                        </tr>
                        </thead>
                        <tbody>
                        <g:each in="${reviewList}" var="reviewInfo">

                            <g:if test="${reviewInfo.status?.equals(MortalityConstants.ACCEPTED) || reviewInfo.status?.equals(MortalityConstants.UPDATED)}">
                                <tr class="tableRow">
                                    <td>
                                        <g:link action="review"
                                                params="[reviewId: reviewInfo?.id]">
                                            <button type="button"
                                                    class="btn btn-primary btnQualityLead btn-xs">Review</button>
                                        </g:link>
                                    </td>
                                    <td><g:link action="review"
                                                params="[reviewId: reviewInfo?.id]">
                                        <span>${reviewInfo?.patientName}</span></g:link></td>
                                    <td><span>${reviewInfo?.facilityCode}</span></td>
                                    <td><span>${reviewInfo?.dischargeDateTime}</span></td>
                                    <td><span>${reviewInfo?.dischargeUnit}</span></td>
                                    <td><span>${reviewInfo?.dischargingDivision}</span></td>
                                    <td><span>${reviewInfo?.statusDateTime}</span></td>
                                    <td><span>${reviewInfo?.statusStr? reviewInfo?.statusStr : reviewInfo?.status}</span></td>
                                    <td>
                                        <button type="button" id="showHistory_${reviewInfo.id}"
                                                class="btn btn-primary btnQualityLead btn-xs"
                                                onclick="showHistory(${reviewInfo.id}, this)">Show History</button>
                                    </td>
                                </tr>
                            </g:if>
                        </g:each>
                        <g:if test="${reviewList.grep{it -> it.status?.equals(MortalityConstants.ACCEPTED) || it.status?.equals(MortalityConstants.UPDATED)}.size()==0}">
                            <tr><td colspan="9">No records found</td></tr>
                        </g:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="row">
            <span class="textTitle">Complete</span>
            <div class="col-md-12 margin_top_-10">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover tableQlead">
                        <thead>
                        <tr class="tableRow">
                            <th>Action</th>
                            <th>Patient Name</th>
                            <th>Hospital</th>
                            <th>Discharge Date</th>
                            <th>Discharging Unit</th>
                            <th>Specialty</th>
                            <th>Status Date/Time</th>
                            <th>Status</th>
                            <th>Status History</th>
                        </tr>
                        </thead>
                        <tbody>
                        <g:each in="${reviewList}" var="reviewInfo">
                            <g:if test="${reviewInfo.status?.equals(MortalityConstants.SUBMITTED) || reviewInfo.status?.equals(MortalityConstants.AMENDED)}">
                                <tr class="tableRow">
                                    <td>
                                        <g:link action="reviewFormOnSave"
                                                params="[reviewId: reviewInfo?.id ]">
                                            <button type="button"
                                                    class="btn btn-primary btnQualityLead btn-xs">Review</button>
                                        </g:link>
                                    </td>
                                    <td><g:link action="reviewFormOnSave"
                                                params="[reviewId: reviewInfo?.id ]">
                                        <span>${reviewInfo?.patientName}</span></g:link></td>
                                    <td><span>${reviewInfo?.facilityCode}</span></td>
                                    <td><span>${reviewInfo?.dischargeDateTime}</span></td>
                                    <td><span>${reviewInfo?.dischargeUnit}</span></td>
                                    <td><span>${reviewInfo?.dischargingDivision}</span></td>
                                    <td><span>${reviewInfo?.statusDateTime}</span></td>
                                    <td><span>${reviewInfo?.status}</span></td>
                                    <td>
                                        <button type="button" id="showHistory_${reviewInfo?.id}"
                                                class="btn btn-primary btnQualityLead btn-xs"
                                                onclick="showHistory(${reviewInfo?.id}, this)">Show History</button>
                                    </td>
                                </tr>
                            </g:if>
                        </g:each>
                        <g:if test="${reviewList.grep{it -> it.status?.equals(MortalityConstants.SUBMITTED) || it.status?.equals(MortalityConstants.AMENDED)}.size()==0}">
                            <tr><td colspan="9">No records found</td></tr>
                        </g:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="dialog" title="Show History">

    </div>
</div>
