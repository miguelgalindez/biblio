package com.example.biblio.resources.rfidReader;

public class RfidTag {
    private String epc;
    private Double rssi;

    public RfidTag(String epc, Double rssi) {
        this.epc = epc;
        this.rssi = rssi;
    }

    public String getEpc() {
        return epc;
    }

    public void setEpc(String epc) {
        this.epc = epc;
    }

    public Double getRssi() {
        return rssi;
    }

    public void setRssi(Double rssi) {
        this.rssi = rssi;
    }
}
