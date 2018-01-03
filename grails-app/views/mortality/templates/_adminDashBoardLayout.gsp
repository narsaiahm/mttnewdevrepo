<%@page import="org.mountsinai.mortalitytriggersystem.MortalityConstants; org.mountsinai.mortalitytriggersystem.AdminConstants"%>
<div class="col-sm-9">
    <span class="fright">Loaded <g:formatDate format="EEE MM-dd-yyyy HH:mm:ss" date="${new Date()}"/></span>
</div>

<div class="col-sm-9">
    <div class="row" id="unassigned_div">
        <span class="textTitle">Unassigned</span>

        <div class="col-md-12 margin_top_-10">
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th>Action</th>
                        <th>Patient Name</th>
                        <th>Hospital</th>
                        <th>Discharge Date</th>
                        <th>Discharging Unit</th>
                        <th>Specialty</th>
                        <th>Days Since Death</th>
                        <th>Status Date/Time</th>
                        <th>Status</th>
                        <th>Status History</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${mortalityReviewList}" var="review">
                        <g:if test="${review.status.equals(MortalityConstants.UNASSIGNED)}">
                            <tr>
                                <td>
                                    <g:link action="assignReviewForm"
                                            params="[reviewId: review.id, reviewFacilityCode: review?.facilityCode, status: review.status, patientName: review.patientName, mrn: review.mrn,expiredDateTime:review?.expiredDateTime,isReviewForm:false]">
                                        <button type="button" class="btn btn-primary btn-xs btn-xs">Assign</button>
                                    </g:link>
                                </td>
                                <td><g:link action="review"
                                            params="[reviewId: review?.id]">${review?.patientName}</g:link></td>
                                <td>${review?.facilityCode}</td>
                                <td>${review?.expiredDateTime}</td>
                                <td>${review?.dischargeUnit}</td>
                                <td>${review?.hospService}</td>
                                <td>${review?.daysSinceDeath}</td>
                                <td>${review?.statusDateTime}</td>
                                <td>${review?.status}</td>
                                <td>
                                    <button type="button"
                                            class="btn btn-primary btnQualityLead btn-xs"
                                            id="showHistory_${review?.id}"
                                            onclick="showHistory(${review?.id}, this)">Show History</button>
                                </td>
                            </tr>
                        </g:if>
                    </g:each>
                    <g:if test="${mortalityReviewList.grep { it -> it.status?.equals(MortalityConstants.UNASSIGNED) }.size() == 0}">
                        <tr><td colspan="10">No records found</td></tr>
                    </g:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="row" id="incomplete_div">
        <span class="textTitle">Incomplete</span>

        <div class="col-md-12 margin_top_-10">
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th>Action</th>
                        <th>Patient Name</th>
                        <th>Hospital</th>
                        <th>Discharge Date</th>
                        <th>Discharging Unit</th>
                        <th>Specialty</th>
                        <th>Assigned To</th>
                        <th>Days Since Death</th>
                        <th>Status Date/Time</th>
                        <th>Status</th>
                        <th>Status History</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${mortalityReviewList}" var="review">
                        <g:if test="${review.status.equals(MortalityConstants.ASSIGNED) || review.status.equals(MortalityConstants.REASSIGNED) || review.status.equals(MortalityConstants.ACCEPTED) || review.status.equals(MortalityConstants.UPDATED)}">
                            <tr>
                                <td>
                                    <g:link action="assignReviewForm"
                                            params="[reviewId: review?.id, reviewFacilityCode: review?.facilityCode, status: review?.status, patientName: review?.patientName, mrn: review?.mrn,lead:review?.lead,role:review?.role,expiredDateTime:review?.expiredDateTime,isReviewForm:false]">
                                        <button type="button" class="btn btn-primary btn-xs btn-xs">Reassign</button>
                                    </g:link>

                                    <g:if test="${review?.daysSinceDeath >= 21}">
                                       <button type="button" style="margin-top: 10px;" id="reminderButtonId" onclick="sendReminderNotification(${review?.id},'${review?.status}')" class="btn btn-primary btn-xs btn-xs">Reminder</button>
                                    </g:if>
                                </td>
                                <td><g:link action="review"
                                            params="[reviewId: review?.id]">${review?.patientName}</g:link></td>
                                <td>${review?.facilityCode}</td>
                                <td>${review?.expiredDateTime}</td>
                                <td>${review?.dischargeUnit}</td>
                                <td>${review?.dischargingDivision}</td>
                                <td>${review?.assignedTo}
                                <g:if test="${review.assignedTo_role.equals(AdminConstants.QUALITY_LEAD)}">
                                    (Clinical Quality Lead)
                                </g:if>
                                <g:else>
                                    (Clinical Reviewer)
                                </g:else>
                                </td>
                                <td>${review?.daysSinceDeath}</td>
                                <td>${review?.statusDateTime}</td>
                                <td>${review?.statusStr}</td>
                                <td>
                                    <button type="button"
                                            class="btn btn-primary btnQualityLead btn-xs"
                                            id="showHistory_${review?.id}"
                                            onclick="showHistory(${review?.id}, this)">Show History</button>
                                </td>
                            </tr>
                        </g:if>
                    </g:each>
                    <g:if test="${mortalityReviewList.grep { it -> it.status?.equals(MortalityConstants.ASSIGNED) || it.status?.equals(MortalityConstants.REASSIGNED) || it.status?.equals(MortalityConstants.ACCEPTED) || it.status?.equals(MortalityConstants.UPDATED) }.size() == 0}">
                        <tr><td colspan="11">No records found</td></tr>
                    </g:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="row" id="complete_div">
        <span class="textTitle">Complete</span>

        <div class="col-md-12 margin_top_-10">
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        %{--<th>Action</th>--}%
                        <th>Patient Name</th>
                        <th>Hospital</th>
                        <th>Discharge Date</th>
                        <th>Discharging Unit</th>
                        <th>Specialty</th>
                        <th>Assigned To</th>
                        <th>Days Since Death</th>
                        <th>Status Date/Time</th>
                        <th>Status</th>
                        <th>Status History</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${mortalityReviewList}" var="review">
                        <g:if test="${review?.status.equals(MortalityConstants.SUBMITTED) || review?.status.equals(MortalityConstants.AMENDED)}">
                            <tr>
                                %{--<td>
                                    <g:link action="reviewFormOnSave"
                                            params="[reviewId: review.id, status: review.status, patientName: review.patientName, mrn: review.mrn]">
                                        <button type="button" class="btn btn-primary btn-xs btn-xs">Amend</button>
                                    </g:link>
                                </td>--}%
                                <td><g:link action="reviewFormOnSave" params="[reviewId: review?.id ]">${review?.patientName}</g:link></td>
                                <td>${review?.facilityCode}</td>
                                <td>${review?.expiredDateTime}</td>
                                <td>${review?.dischargeUnit}</td>
                                <td>${review?.dischargingDivision}</td>
                                <td>${review?.assignedTo}
                                <g:if test="${review.assignedTo_role.equals(AdminConstants.QUALITY_LEAD)}">
                                    (Clinical Quality Lead)
                                </g:if>
                                <g:else>
                                    (Clinical Reviewer)
                                </g:else>
                                </td>
                                <td>${review?.daysSinceDeath}</td>
                                <td>${review?.statusDateTime}</td>
                                <td>${review?.status}</td>
                                <td>
                                    <button type="button"
                                            class="btn btn-primary btnQualityLead btn-xs"
                                            id="showHistory_${review?.id}"
                                            onclick="showHistory(${review?.id}, this)">Show History</button>
                                </td>
                            </tr>
                        </g:if>
                    </g:each>
                    </tbody>
                    <g:if test="${mortalityReviewList.grep { it -> it.status?.equals(MortalityConstants.SUBMITTED) || it.status?.equals(MortalityConstants.AMENDED) }.size() == 0}">
                        <tr><td colspan="11">No records found</td></tr>
                    </g:if>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="dialog" title="Status History">

</div>
