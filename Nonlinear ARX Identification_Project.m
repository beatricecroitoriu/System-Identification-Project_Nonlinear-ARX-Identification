clear all
close all
clc

load('iddata-01.mat')

uid = id.u;
yid = id.y;

uval = val.u;
yval = val.y;

%subplot(2, 1, 1)
%plot(uid)
%subplot(2, 1, 2)
%plot(yid)
%figure
%subplot(2, 1, 1)
%plot(uval)
%subplot(2, 1, 2)
%plot(yval)
%figure

na = 1;
nb = 2;
nk = 1;
m = 3;

vp = puteri(na, nb, m);

%predictie identificare

d = zeros;
phi_id = zeros;

for  k = 1 : length(uid)
    for i = 1 : na
        if k - i <= 0
            d(k, i) = 0;
        else
            d(k, i) = -yid(k - i);
        end
    end

    for j = 1 : nb
        if k - j - nk + 1 <= 0
            d(k, na + j) = 0;
        else
            d(k, na + j) = uid(k - j - nk + 1);
        end
    end

    for p = 1 : length(vp)
        phi_id(k, p) = 1;
        for j = 1 : na + nb
            phi_id(k, p) = phi_id(k, p) * (d(k, j) ^ vp(p, j));
        end  
    end   
end

theta = phi_id \ yid;

yid_pred = phi_id * theta;

s = 0;
for i = 1 : length(yid)
    s = s + (yid(i) - yid_pred(i))^2;
end
MSEid_pred = 1/length(yid) * s;

plot(yid, 'b')
hold on
plot(yid_pred, 'r')
legend('iesire identificare', 'predictie')
title('Predictie identificare')
    
%simulare identificare

xs_id = zeros;
yid_sim = zeros(length(uid), 1);
phis_id = zeros;

for  k = 1 : length(uid)
    for i = 1 : na
        if k - i <= 0
            xs_id(k, i) = 0;
        else
            xs_id(k, i) = -yid_sim(k - i);
        end
    end

    for j = 1 : nb
        if k - j - nk + 1 <= 0
            xs_id(k, na + j) = 0;
        else
            xs_id(k, na + j) = uid(k - j - nk + 1);
        end
    end

    for p = 1 : length(vp)
        phis_id(k, p) = 1;
        for j = 1 : na + nb
            phis_id(k, p) = phis_id(k, p) * (xs_id(k, j) ^ vp(p, j));
        end  
    end
    yid_sim(k) = phis_id(k,:) * theta;
end

s = 0;
for i = 1 : length(yid)
    s = s + (yid(i) - yid_sim(i))^2;
end
MSEid_sim = 1/length(yid) * s;

figure
plot(yid, 'b')
hold on
plot(yid_sim, 'r')
legend('iesire identificare','simulare')
title('Simulare identificare')

%predictie validare

d = zeros;
phi_val = zeros;

for  k = 1 : length(uval)
    for i = 1 : na
        if k - i <= 0
            d(k, i) = 0;
        else
            d(k, i) = -yval(k - i);
        end
    end

    for j = 1 : nb
        if k - j - nk + 1 <= 0
            d(k, na + j) = 0;
        else
            d(k, na + j) = uval(k - j - nk + 1);
        end
    end

    for p = 1 : length(vp)
        phi_val(k, p) = 1;
        for j = 1 : na + nb
            phi_val(k, p) = phi_val(k, p) * (d(k, j) ^ vp(p, j));
        end  
    end   
end

yval_pred = phi_val * theta;

s = 0;
for i = 1 : length(yval)
    s = s + (yval(i) - yval_pred(i))^2;
end
MSEval_pred = 1/length(yval) * s;

figure
plot(yval, 'b')
hold on
plot(yval_pred, 'r')
legend('iesire identificare', 'predictie')
title('Predictie validare')
    
%simulare validare

xs_val = zeros;
yval_sim = zeros(length(uval), 1);
phis_val = zeros;

for  k = 1 : length(uval)
    for i = 1 : na
        if k - i <= 0
            xs_val(k, i) = 0;
        else
            xs_val(k, i) = -yval_sim(k - i);
        end
    end

    for j = 1 : nb
        if k - j - nk + 1 <= 0
            xs_val(k, na + j) = 0;
        else
            xs_val(k, na + j) = uval(k - j - nk + 1);
        end
    end

    for p = 1 : length(vp)
        phis_val(k, p) = 1;
        for j = 1 : na + nb
            phis_val(k, p) = phis_val(k, p) * (xs_val(k, j) ^ vp(p, j));
        end  
    end
    yval_sim(k) = phis_val(k,:) * theta;
end

s = 0;
for i = 1 : length(yval)
    s = s + (yval(i) - yval_sim(i))^2;
end
MSEval_sim = 1/length(yval) * s;

figure
plot(yval, 'b')
hold on
plot(yval_sim, 'r')
legend('iesire identificare','simulare')
title('Simulare validare')

function vp = puteri(na, nb, m)
    vp = zeros;
    
    for i = 1 : m + 1
        vp(i) = i - 1;
    end
    
    vp = unique(nchoosek(repmat(vp, 1, na + nb), na + nb),'rows');
    
    k = 1;
    while(k <= length(vp))
        if(sum(vp(k,:)) > m)
            vp(k,:) = [];
            k = k - 1;
        end
        k = k + 1;
    end
end