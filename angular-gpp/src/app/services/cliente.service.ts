import { environment } from 'src/environments/environment';
import { Injectable } from '@angular/core';
import { ClienteModel } from '../models/ClienteModel';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ClienteService {

  public clientes: ClienteModel[] = [];

  constructor(private httpClient: HttpClient) { }

  public add(cliente: ClienteModel): Observable<any>{
    return this.httpClient.post(`${environment.url}/cliente`, cliente);
  }

  public get(idx: number): Observable<any>{
    return this.httpClient.get(`${environment.url}/cliente/${idx}`);
  }

  public list(): Observable<any>{
    console.log(this.httpClient.get(`${environment.url}/cliente`))
    return this.httpClient.get(`${environment.url}/cliente`);
  }

}