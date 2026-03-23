// Dashboard Chart Functions
let charts = {};

window.createBarChart = function (canvasId, labels, data1, data2, label1, label2) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    // Destroy existing chart
    if (charts[canvasId]) {
        charts[canvasId].destroy();
    }

    const datasets = [{
        label: label1,
        data: data1,
        backgroundColor: 'rgba(40, 167, 69, 0.7)',
        borderColor: 'rgba(40, 167, 69, 1)',
        borderWidth: 1
    }];

    if (data2 && data2.some(v => v > 0)) {
        datasets.push({
            label: label2,
            data: data2,
            backgroundColor: 'rgba(220, 53, 69, 0.7)',
            borderColor: 'rgba(220, 53, 69, 1)',
            borderWidth: 1
        });
    }

    charts[canvasId] = new Chart(ctx, {
        type: 'bar',
        data: { labels: labels, datasets: datasets },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'top' },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.dataset.label + ': ' + context.raw.toLocaleString('tr-TR') + ' TL';
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return value >= 1000 ? (value/1000) + 'K' : value;
                        }
                    }
                }
            }
        }
    });
};

window.createLineChart = function (canvasId, labels, data1, data2) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    // Destroy existing chart
    if (charts[canvasId]) {
        charts[canvasId].destroy();
    }

    const datasets = [{
        label: 'Toplam',
        data: data1,
        fill: true,
        backgroundColor: 'rgba(220, 53, 69, 0.1)',
        borderColor: 'rgba(220, 53, 69, 1)',
        borderWidth: 2,
        tension: 0.3,
        pointBackgroundColor: 'rgba(220, 53, 69, 1)',
        pointRadius: 3
    }];

    if (data2 && data2.some(v => v > 0)) {
        datasets.push({
            label: 'Odenen',
            data: data2,
            fill: true,
            backgroundColor: 'rgba(40, 167, 69, 0.1)',
            borderColor: 'rgba(40, 167, 69, 1)',
            borderWidth: 2,
            tension: 0.3,
            pointBackgroundColor: 'rgba(40, 167, 69, 1)',
            pointRadius: 3
        });
    }

    charts[canvasId] = new Chart(ctx, {
        type: 'line',
        data: { labels: labels, datasets: datasets },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'top', labels: { boxWidth: 12, font: { size: 10 } } },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.dataset.label + ': ' + context.raw.toLocaleString('tr-TR') + ' TL';
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return value >= 1000 ? (value/1000) + 'K' : value;
                        },
                        font: { size: 10 }
                    }
                },
                x: {
                    ticks: { font: { size: 9 } }
                }
            }
        }
    });
};

window.createDoughnutChart = function (canvasId, labels, data, colors) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    // Destroy existing chart
    if (charts[canvasId]) {
        charts[canvasId].destroy();
    }

    charts[canvasId] = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: data,
                backgroundColor: colors,
                borderWidth: 2,
                borderColor: '#fff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const pct = Math.round((context.raw / total) * 100);
                            return context.label + ': ' + context.raw.toLocaleString('tr-TR') + ' TL (' + pct + '%)';
                        }
                    }
                }
            }
        }
    });
};
