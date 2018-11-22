package com.hwua.ssm.entity;

public class Auth {

    private Integer id;
    private Integer pid;
    private String authname;
    private String authcode;
    private String type;
    private String url;
    private String status;
    private Integer orders;

    public Auth() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getPid() {
        return pid;
    }

    public void setPid(Integer pid) {
        this.pid = pid;
    }

    public String getAuthname() {
        return authname;
    }

    public void setAuthname(String authname) {
        this.authname = authname;
    }

    public String getAuthcode() {
        return authcode;
    }

    public void setAuthcode(String authcode) {
        this.authcode = authcode;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String stauts) {
        this.status = stauts;
    }

    public Integer getOrders() {
        return orders;
    }

    public void setOrders(Integer orders) {
        this.orders = orders;
    }

    @Override
    public String toString() {
        return "Auth{" +
                "id=" + id +
                ", pid=" + pid +
                ", authname='" + authname + '\'' +
                ", authcode='" + authcode + '\'' +
                ", type='" + type + '\'' +
                ", url='" + url + '\'' +
                ", status='" + status + '\'' +
                ", orders=" + orders +
                '}';
    }
}
