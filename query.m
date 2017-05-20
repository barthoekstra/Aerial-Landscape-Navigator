device_numbers = [1600];
starttime = '2014-05-01  00:00:00';
stoptime  = '2014-07-15  00:00:00';

start = strcat('''', starttime, '''');
stop = strcat('''', stoptime, '''');      

boundingbox = [4.467741311655249,52.279259093795160;5.430562872339879,53.197395781010660];
% ' COUNT(*) OVER (PARTITION BY t.date_time), ', ...

sql = strcat('SELECT t.device_info_serial, t.date_time, a.date_time, ', ...
            ' date_part(''year''::text, t.date_time) AS year, ', ...
            ' date_part(''month''::text, t.date_time) AS month, ', ...
            ' date_part(''day''::text, t.date_time) AS day, ', ...
            ' date_part(''hour''::text, t.date_time) AS hour, ', ...
            ' date_part(''minute''::text, t.date_time) AS minute, ', ...
            ' date_part(''second''::text, t.date_time) AS second, ', ...
            ' t.longitude, t.latitude, t.altitude, t.temperature, t.gps_fixtime, ', ...
            ' t.speed_3d AS speed3d, t.speed_2d AS speed, t.altitude_agl, ', ...
            ' t.positiondop, t.satellites_used, COUNT(a.index) AS n_acc_points,  ', ...
            ' a.index, (a.x_acceleration-d.x_o)/d.x_s AS x_cal, ', ...
            ' (a.y_acceleration-d.y_o)/d.y_s AS y_cal, ', ...
            ' (a.z_acceleration-d.z_o)/d.z_s AS z_cal, ', ...
            ' DATE(t.date_time) AS date, ', ...
            ' COUNT(*) OVER (PARTITION BY DATE(t.date_time)) AS n_acc_obs_day, ', ...
            ' p.key_name AS project ', ...
            ' FROM gps.ee_tracking_speed_limited t' , ...
            ' LEFT JOIN gps.ee_acceleration_limited a' , ...
            ' ON (t.device_info_serial = a.device_info_serial AND t.date_time = a.date_time)' , ...
            ' LEFT JOIN gps.ee_tracker_limited d ', ...
            ' ON a.device_info_serial = d.device_info_serial ', ...
            ' LEFT JOIN gps.ee_tracker_ownership_limited p', ...
            ' ON (t.device_info_serial = p.device_info_serial)', ...
            ' WHERE ( t.date_time >= ', start,  ')', ...
            ' AND ( t.date_time <= ', stop,    ')' , ...
            ' AND ( t.device_info_serial = ', num2str(device_numbers), ')', ...
            ' AND ( t.longitude >= ', num2str(boundingbox(1,1)), ')', ...
            ' AND ( t.longitude <= ', num2str(boundingbox(2,1)), ')', ...
            ' AND ( t.latitude >= ', num2str(boundingbox(1,2)), ')', ...
            ' AND ( t.latitude <= ', num2str(boundingbox(2,2)), ')', ...
            ' AND t.userflag = 0', ...
            ' GROUP BY p.key_name,  t.device_info_serial, t.date_time, a.date_time, t.longitude, ' , ...
            ' t.speed_2d, t.speed_3d, t.altitude_agl,' , ...
            ' t.latitude, t.altitude, t.temperature, t.gps_fixtime, t.positiondop, t.satellites_used, t.location, ' , ...
            ' a.index, a.x_acceleration, d.x_o, d.x_s, a.y_acceleration, d.y_o, d.y_s, ' , ...
            ' a.z_acceleration, d.z_o, d.z_s' , ...
            ' ORDER BY t.date_time' );
        
%         sql1 = strcat('SELECT s.device_info_serial, s.date_time, ', ...
%                ' a.index,(a.x_acceleration-d.x_o)/d.x_s as x_cal, ',...
%                ' (a.y_acceleration-d.y_o)/d.y_s as y_cal, ',...
%                ' (a.z_acceleration-d.z_o)/d.z_s as z_cal ',...
%                ' FROM gps.uva_tracking_data101 s ',...
%                ' LEFT join gps.uva_accelepgadmration101 a ',...  
%                ' ON (s.device_info_serial = a.device_info_serial AND s.date_time = a.date_time) ',...
%                ' LEFT join gps.ee_tracker d ',...
%                ' ON a.device_info_serial = d.device_info_serial ',...
%                ' LEFT join gps.get_uvagps_track_speed (',IDevice, ',' ,start, ',' ,stop, ' ) t ',...
%                ' ON s.device_info_serial = t.device_info_serial and s.date_time = t.date_time ',...
%                ' where s.device_info_serial = ',IDevice , ' and ',...
%                ' s.date_time >', start, ' and s.date_time < ' ,stop, ' and s.latitude is not null and s.userflag <> 1 ',...
%                ' order by  s.date_time, a.index');